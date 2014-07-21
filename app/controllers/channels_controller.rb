class ChannelsController < ApplicationController
	before_filter :require_user, :except => [ :show, :post_data, :post_profile, :friendship_list, :groupmembers ]
	before_filter :set_channels_menu
	protect_from_forgery :except => [:post_data , :post_profile]
	require 'csv'
  require 'time'

	def index
		@channels = current_user.channels
	end

	def show
		@channel = Channel.find(params[:id]) if params[:id]
		@domain = domain

    compute_friendship

		get_channel_data if current_user and @channel.user_id == current_user.id
  end

  def compute_friendship
    @oor=Channel.find_all_by_user_id("#{current_user.id}", :conditions => ["id <> ?", @channel.id])
    if @channel.model.blank?
      @por=[]
    else
      @por=Channel.find_all_by_model(@channel.model, :conditions => ["id <> ?", @channel.id])
    end
    if @channel.location.blank?
      @clor=[]
    else
      if @channel.clor_flag and !@channel.mobility_status
        @clor=Channel.find_all_by_location(@channel.location, :conditions => ["clor_flag = 1 AND mobility_status = 0 AND id <> ?",@channel.id])
      end
      end
    if @channel.sor_flag
      @sor=[]
      @sor1=Relationship.find_all_by_guid_one(params[:id], :conditions => ['relation = "SOR"'])
      @sor1.each do |elemento|
        unless Relationship.find_all_by_guid_one(elemento.guid_two, :conditions => ['relation = "SOR"']).empty?
          @sor.push(Channel.find(elemento.guid_two))
        end
      end
      #puts @sor
    end
    if @channel.cwor_flag
      @cwor=[]
      @cwor1=Relationship.find_all_by_guid_one(params[:id], :conditions => ['relation = "CWOR"'])
      @cwor1.each do |elemento|
        unless Relationship.find_all_by_guid_one(elemento.guid_two, :conditions => ['relation = "CWOR"']).empty?
          @cwor.push(Channel.find(elemento.guid_two))
        end
      end
    end
  end



	def edit
		get_channel_data
    @allplaces  = Place.all.to_gmaps4rails      do |place,marker|
      marker.json({:name => place.name, :id => place.id, :work => place.work, :public => place.public, :home => place.home})
    end
    session[:canale]=@channel.id
    gon.prova=@channel.mobility_status
  end

  def new
    get_channel_data
  end

	def update
		@channel = current_user.channels.find(params[:id])
		@channel.update_attributes(params[:channel])
		redirect_to channel_path(@channel.id)
	end

  def create
    channel = current_user.channels.create
    channel.add_write_api_key
    channel.add_read_api_key
   
    # redirect to edit the newly created channel 
    redirect_to edit_channel_path(channel)
  end

  # clear all data from a channel
  def clear
    channel = current_user.channels.find(params[:id])
    channel.delete_feeds
    channel.update_attribute(:last_entry_id, nil)

    redirect_to channels_path
	end

	def destroy
		channel = current_user.channels.find(params[:id])
		channel.destroy

		redirect_to channels_path
  end

  def indirect_location

   if !Channel.find_all_by_bt_mac_address(@feedex.field5).nil?  and (@feedex.gps_precision.blank? or @feedex.gps_precision > 10)
     @chanref=Channel.find_by_bt_mac_address(@feedex.field5) if !@feedex.field5.blank?
     if (!@chanref.blank? and !@chanref.mobility_status?)
          @refpoint=Place.find(@chanref.location)
          end
     if !@refpoint.blank?
       @feedex.field6=@refpoint.latitude
       @feedex.field7=@refpoint.longitude
       @feedex.gps_precision=10
       return
     end
   else
     if !Channel.find_all_by_wf_mac_address(@feedex.field5).nil? and (@feedex.gps_precision.blank? or @feedex.gps_precision > 100)
       @chanref=Channel.find_all_by_wf_mac_address(@feedex.field5).first if !@feedex.field5.blank?
       @refpoint=Place.find(@chanref.location) if !@chanref.blank?
       if !@refpoint.blank?
         @feedex.field6=@refpoint.latitude
         @feedex.field7=@refpoint.longitude
         @feedex.gps_precision=100
         return
      end
     end
   end
   end

  def relation_demo
    salta=0
    if ((Channel.find(@device).mobility_status and !Channel.find(@meeted[0].id).mobility_status and Channel.find(@meeted[0]).location_type == 2)) or (!Channel.find(@device).mobility_status and Channel.find(@meeted[0].id).mobility_status and Channel.find(@device).location_type == 2)
      if Relationship.find_all_by_guid_one(@device, :conditions => ["guid_two=?",@meeted[0].id]).empty?

        relazioni=Relationship.new
        relazioni.time_created=DateTime.now
        relazioni.guid_one=@device
        relazioni.guid_two=@meeted[0].id
        relazioni.relation="CWOR"
        if relazioni.save
          puts "relazione ok"
        end
        puts "friendship request sent"
        salta=1
      else
        puts "waiting for more contacts"
      end
    end
    if (Relationship.find_all_by_guid_one(@device, :conditions => ["guid_two=?",@meeted[0].id]).empty? and salta==0)

      relazioni=Relationship.new
      relazioni.time_created=DateTime.now
      relazioni.guid_one=@device
      relazioni.guid_two=@meeted[0].id
      relazioni.relation="SOR"
      if relazioni.save
        puts "relazione ok"
      end
      puts "friendship request sent"
    else
      puts "waiting for more contacts"
    end
  end




  def relationship_management
    if ((Channel.find(@device).mobility_status and !Channel.find(@meeted[0].id).mobility_status and Channel.find(@meeted[0]).location_type == 2)) or (!Channel.find(@device).mobility_status and Channel.find(@meeted[0].id).mobility_status and Channel.find(@device).location_type == 2)
      puts "eccomi qui"
      @lastfeed=Feed.find_all_by_channel_id(@device, :order => "entry_id DESC")
      i=0
      condition=false

      until (@lastfeed[0].created_at - @lastfeed[i].created_at) > 1800           #30 min
        puts (@lastfeed[0].created_at - @lastfeed[i].created_at)
        puts  "dentro until"
        puts i
        if @lastfeed[i+1].blank?
          condition=false
          puts "interrotto per condizione 1"
          break
        end
        if ((@lastfeed[i].created_at - @lastfeed[i+1].created_at)  > 600)
         # puts  "dentro if"
          puts "interrotto per condizione 2"
          condition=false
          break
        end
        i=i+1
        condition=true
      end

      if condition  and Relationship.find_all_by_guid_one(@device, :conditions => ["guid_two=?",@meeted[0].id]).empty?

        relazioni=Relationship.new
        relazioni.time_created=DateTime.now
        relazioni.guid_one=@device
        relazioni.guid_two=@meeted[0].id
        relazioni.relation="CWOR"
        if relazioni.save
          puts "relazione ok"
        end
        puts "friendship request sent"
      else
        puts "waiting for more contacts"
      end

    else

      puts "calcolo sor"

    @lastfeed=Feed.find_all_by_channel_id(@device, :order => "entry_id DESC")
    i=1
    firstcondition=false
    if !@lastfeed[i].nil?
      until (@lastfeed[0].created_at - @lastfeed[i].created_at) > 1800
            if (!@lastfeed[i].nil? and @lastfeed[i-1].created_at - @lastfeed[i].created_at  > 600)#600
              puts "dentro if"
              firstcondition=false
              break
            end
            i=i+1
        if @lastfeed[i].nil?
          firstcondition=false
          break
        end
            firstcondition=true
      end
     end
    j=i+1
    puts firstcondition
    secondcondition=false
    if firstcondition and !@lastfeed[j].nil? and (@lastfeed[j-1].created_at - @lastfeed[j+1].created_at) > 28800      #VERIFICARE ENTRY_ID ERRORE UNDEFINED METHOD NIL.CLASS
      puts "second block"
      until (@lastfeed[i].created_at - @lastfeed[j].created_at) > 1800
        if @lastfeed[j-1].created_at - @lastfeed[j].created_at  > 300
          secondcondition=false
          break
        end
        j=j+1
        if @lastfeed[j].nil?
          secondcondition=false
          break
        end
        secondcondition=true
      end
    end
     puts secondcondition
    if secondcondition  and Relationship.find_all_by_guid_one(@device, :conditions => ["guid_two=?",@meeted[0].id]).empty?
      relazioni=Relationship.new
      relazioni.time_created=DateTime.now
      relazioni.guid_one=@device
      relazioni.guid_two=@meeted[0].id
      relazioni.relation="SOR"
      if relazioni.save
        puts "friendship request sent"
      end
      else
        if firstcondition
          puts "first meeting done"
        else
          puts "waiting for more contacts"
        end
    end

    end

  end

  # response is '0' if failure, 'entry_id' if success
	def post_data
		status = '0'
		feed = Feed.new
	
		api_key = ApiKey.find_by_api_key(get_userkey)

		# if write persmission, allow post
		if (api_key && api_key.write_flag)
			channel = Channel.find(api_key.channel_id)

			# update entry_id for channel and feed
			entry_id = channel.last_entry_id.nil? ? 1 : channel.last_entry_id + 1
			channel.last_entry_id = entry_id
			feed.entry_id = entry_id

			# try to get created_at datetime if appropriate
			if params[:created_at]
				begin
					feed.created_at = DateTime.parse(params[:created_at])
				# if invalid datetime, don't do anything--rails will set created_at
				rescue
				end
			end
		
			# modify parameters
			params.each do |key, value|
				# strip line feeds from end of parameters
				params[key] = value.sub(/\\n$/, '').sub(/\\r$/, '') if value
				# use ip address if found
				params[key] = request.remote_addr if value.upcase == 'IP_ADDRESS'
			end
	
			# set feed details
			feed.channel_id = channel.id
			feed.raw_data = params
			feed.field1 = params[:field1] if params[:field1]
			feed.field2 = params[:field2] if params[:field2]
			feed.field3 = params[:field3] if params[:field3]
			feed.field4 = params[:field4] if params[:field4]
			feed.field5 = params[:field5] if params[:field5]
			feed.field6 = params[:field6] if params[:field6]
			feed.field7 = params[:field7] if params[:field7]
			feed.field8 = params[:field8] if params[:field8]
      feed.field9 = params[:field9] if params[:field9]
      feed.field10 = params[:field10] if params[:field10]
      feed.field11 = params[:field11] if params[:field11]
      feed.field12 = params[:field12] if params[:field12]
      feed.field13 = params[:field13] if params[:field13]
      feed.field14 = params[:field14] if params[:field14]
      feed.field15 = params[:field15] if params[:field15]
      feed.field16 = params[:field16] if params[:field16]
      feed.gps_precision = params[:gps_precision] if params[:gps_precision]
			feed.status = params[:status] if params[:status]

      #localizzazione indiretta
      if (channel.mobility_status? and channel.aut_ind_loc? and params[:field5])
        if ((feed.gps_precision.blank? or feed.gps_precision > 10))
          @feedex=feed
          indirect_location
          feed.field6=@feedex.field6
          feed.field7=@feedex.field7
          feed.gps_precision=@feedex.gps_precision

        end

      end
      #group management
      if !feed.field13.blank?
        @textfield=feed.field13
        @channel_id=channel.id
        group_management
      end
      if !feed.field14.blank?
        @textfield=feed.field14
        @channel_id=channel.id
        group_management
      end
      if !feed.field15.blank?
        @textfield=feed.field15
        @channel_id=channel.id
        group_management
      end
      if !feed.field16.blank?
        @textfield=feed.field16
        @channel_id=channel.id
        group_management
      end

      #salva i feed inviati
			if channel.save && feed.save
				status = entry_id
			end
    end

    #relatioship management
    if params[:field5] and (!Channel.find_all_by_bt_mac_address(params[:field5]).blank? or !Channel.find_all_by_wf_mac_address(params[:field5]).blank?)
      puts "si comincia!"
      @device=channel.id
      if !Channel.find_all_by_bt_mac_address(params[:field5]).empty?
        @meeted=Channel.find_all_by_bt_mac_address(params[:field5])
      else
        @meeted=Channel.find_all_by_wf_mac_address(params[:field5])
      end
      @entryid=status

      if Relationship.find_all_by_guid_one(@device, :conditions => ["guid_two=?",@meeted[0].id]).empty?
       # relationship_management
        relation_demo
      end
    end
		# output response code
		render :text => '0', :status => 400 and return if status == '0'
		render :text => status

  end


  def post_profile
    status = '0'


    api_key = ApiKey.find_by_api_key(get_userkey)

    # if write permission, allow post
    if (api_key && api_key.write_flag)
      channel = Channel.find(api_key.channel_id)
      channel.model=params[:model] if params[:model]
      channel.brand=params[:brand] if params[:brand]
      channel.device_type=params[:device_type] if params[:device_type]
      channel.bt_mac_address=params[:bt_mac_address] if params[:bt_mac_address]
      channel.wf_mac_address=params[:wf_mac_address] if params[:wf_mac_address]
      channel.mobility_status=params[:mobile_status] if params[:mobile_status]
      channel.aut_ind_loc=params[:aut_ind_loc] if (params[:aut_ind_loc] and channel.mobility_status)
      channel.public_flag=params[:public_flag] if params[:public_flag]
      channel.oor_flag=params[:oor_flag] if params[:oor_flag]
      channel.clor_flag=params[:clor_flag] if params[:clor_flag]
      channel.por_flag=params[:por_flag] if params[:por_flag]
      channel.cwor_flag=params[:cwor_flag] if params[:cwor_flag]
      channel.sor_flag=params[:sor_flag] if params[:sor_flag]
      channel.field1='Temperature' if params[:field1]
      channel.field2='Current' if params[:field2]
      channel.field3='Voltage' if params[:field3]
      channel.field4='Power' if params[:field4]
      channel.field5='Nearby Mac Address' if params[:field5]
      channel.field6='Latitude' if params[:field6]
      channel.field7='Longitude' if params[:field7]
      channel.field8='Humidity' if params[:field8]
      channel.field9='Pressure' if params[:field9]
      channel.field10='Weight' if params[:field10]
      channel.field11='Presence' if params[:field11]
      channel.field12='Alarm' if params[:field12]
      channel.field13=params[:field13] if params[:field13]
      channel.field14=params[:field14] if params[:field14]
      channel.field15=params[:field15] if params[:field15]
      channel.field16=params[:field16] if params[:field16]

      if channel.save
        status = 1
      end
    end
    # output response code
    render :text => '0', :status => 400 and return if status == '0'
    render :text => status

  end

  #restituisce la lista di amicizie
  def friendship_list
    status = '0'

    api_key = ApiKey.find_by_api_key(get_userkey)
    if api_key.write_flag
      @channel=Channel.find(api_key.channel_id)
      current_user=User.find(@channel.user_id)
      #puts current_user.id

      if !@channel.oor_flag.blank?
        @oor=[]
        Channel.where('user_id = ? AND id <> ?',current_user.id, @channel.id).each do |c|
          @oor.push(ApiKey.where('channel_id = ? AND write_flag = FALSE', c.id).select('api_key, channel_id'))
        end
      end
      if !@channel.model.blank?
        @por=[]
        Channel.where('model = ? AND id <> ?',@channel.model, @channel.id).each do |c|
           @por.push(ApiKey.where('channel_id = ? AND write_flag = FALSE', c.id).select('api_key, channel_id'))
        end
      end
      if !@channel.location.blank? and !@channel.mobility_status
        @clor=[]
        Channel.where('location = ? AND id <> ? AND mobility_status = FALSE',@channel.location, @channel.id).each do |c|
          @clor.push(ApiKey.where('channel_id = ? AND write_flag = FALSE', c.id).select('api_key, channel_id'))
        end
      end
        if @channel.sor_flag
          @sor=[]
          Relationship.where('guid_one = ? AND relation = "SOR"', @channel.id).each do |elemento|
            if !Relationship.where('guid_one = ? AND relation = "SOR" AND guid_two = ?',elemento.guid_two, @channel.id).empty?
              @sor.push(ApiKey.where('channel_id = ? AND write_flag = FALSE', elemento.guid_two).select('api_key, channel_id'))
            end
          end
        end
      if @channel.cwor_flag
        @cwor=[]
        Relationship.where('guid_one = ? AND relation = "CWOR"', @channel.id).each do |elemento|
          if !Relationship.where('guid_one = ? AND relation = "CWOR" AND guid_two = ?',elemento.guid_two, @channel.id).empty?
            @cwor.push(ApiKey.where('channel_id = ? AND write_flag = FALSE', elemento.guid_two).select('api_key, channel_id'))
          end
        end
      end

      respond_to do |format|
          format.json {render :json => {:oor => @oor, :por => @por, :clor => @clor, :sor => @sor, :cwor => @cwor}.to_json(:root => 'relationship')}
          format.xml {render :xml => {:oor => @oor, :por => @por, :clor => @clor, :sor => @sor, :cwor => @cwor}.to_xml(:root => 'relationship')}
      end
    else
      render :text => "forbidden"
      end

  end

  #restituisce la lista dei partecipanti ai gruppi
  def groupmembers
    status = '0'
    api_key = ApiKey.find_by_api_key(get_userkey)
    if api_key.write_flag
    @channel=Channel.find(api_key.channel_id)
    @groupmem=[]
    GroupRelation.find_all_by_channel_id(@channel.id).each do |elemento|
      @memberstemp=[]
      @members=[]
      @members=GroupRelation.find_all_by_group_id(elemento.group_id, :conditions => ["channel_id <> ?", @channel.id])
      @members.each do |elem|
        @memberstemp.push(ApiKey.where("channel_id=? AND write_flag = FALSE", elem.channel_id).select("api_key, channel_id"))
      end
      @gtemp={'group' => Group.find(elemento.group_id),'members' => @memberstemp}
      @groupmem.push(@gtemp)
    end

    respond_to do |format|
      format.json {render :json => @groupmem}
      format.xml  {render :xml => @groupmem}
    end
    else
      render :text => "forbidden"
      end
  end


	# import view
	def import
		get_channel_data
	end

	# upload csv file to channel
	def upload
		# if no data
		render :text => t(:select_file) and return if params[:upload].blank? or params[:upload][:csv].blank?

		channel = Channel.find(params[:channel_id])
		channel_id = channel.id
		# make sure channel belongs to current user
		check_permissions(channel)
		
		# set time zone
		Time.zone = params[:feed][:time_zone]

		# read data from uploaded file
		csv_array = CSV.parse(params[:upload][:csv].read)

		# does the column have headers
		headers = has_headers?(csv_array)

		# remember the column positions
		entry_id_column = -1
		status_column = -1
		if headers
			csv_array[0].each_with_index do |column, index|
				entry_id_column = index if column.downcase == 'entry_id'
				status_column = index if column.downcase == 'status'
			end
		end

		# delete the first row if it contains headers
		csv_array.delete_at(0) if headers

		# determine if the date can be parsed
		parse_date = date_parsable?(csv_array[0][0])

		# if 2 or more rows
		if !csv_array[1].blank?
			date1 = parse_date ? Time.parse(csv_array[0][0]) : Time.at(csv_array[0][0])
			date2 = parse_date ? Time.parse(csv_array[1][0]) : Time.at(csv_array[1][0])

			# reverse the array if 1st date is larger than 2nd date
			csv_array = csv_array.reverse if date1 > date2
		end

		# loop through each row
		csv_array.each do |row|
			# if row isn't blank
			if !row.blank?
				feed = Feed.new
	
				# set location and status then delete the rows
				# these 4 deletes must be performed in the proper (reverse) order
				feed.status = row.delete_at(status_column) if status_column > 0

				# remove entry_id column if necessary
				row.delete_at(entry_id_column) if entry_id_column > 0

				# update entry_id for channel and feed
				entry_id = channel.last_entry_id.nil? ? 1 : channel.last_entry_id + 1
				channel.last_entry_id = entry_id
				feed.entry_id = entry_id
	
				# set feed data
				feed.channel_id = channel_id
				feed.created_at = parse_date ? Time.zone.parse(row[0]) : Time.zone.at(row[0].to_f)
				feed.raw_data = row.to_s
				feed.field1 = row[1]
				feed.field2 = row[2]
				feed.field3 = row[3]
				feed.field4 = row[4]
				feed.field5 = row[5]
				feed.field6 = row[6]
				feed.field7 = row[7]
				feed.field8 = row[8]
        feed.field9 = row[9]
        feed.field10 = row[10]
        feed.field11 = row[11]
        feed.field12 = row[12]
        feed.field13 = row[13]
        feed.field14 = row[14]
        feed.field15 = row[15]
        feed.field16 = row[16]


				# save channel and feed
				feed.save
				channel.save

			end
		end

		# set the user's time zone back
		set_time_zone(params)

		# redirect 
		redirect_to channel_path(channel.id)
	end


private

	# determine if the date can be parsed
	def date_parsable?(date)
		return !is_a_number?(date)
	end

	# determine if the csv file has headers
	def has_headers?(csv_array)
		headers = false

		# if there are at least 2 rows
		if (csv_array[0] and csv_array[1])
			row0_integers = 0
			row1_integers = 0	
	
			# if first row, first value contains 'create' or 'date', assume it has headers
			if (csv_array[0][0].downcase.include?('create') or csv_array[0][0].downcase.include?('date'))
				headers = true
			else
				# count integers in row0
				csv_array[0].each_with_index do |value, i|
					row0_integers += 1 if is_a_number?(value)
				end
	
				# count integers in row1
				csv_array[1].each_with_index do |value, i|
					row1_integers += 1 if is_a_number?(value)
				end
	
				# if row1 has more integers, assume row0 is headers
				headers = true if row1_integers > row0_integers
			end
		end

		return headers
  end

  #crea i gruppi in base agli hash-tag
  def group_management
      group_tags=@textfield.scan( /\B#(\w+)/ )
      group_tags.each do |tag|
        if Group.find_all_by_tag1(tag[0]).blank?
          Group.create tag1: tag[0]
        else
          groupx=Group.find_all_by_tag1(tag).first
          #puts @channel_id
          if GroupRelation.find_all_by_channel_id(@channel_id, :conditions => ["group_id = ?", groupx.id]).blank?
            groupofint=GroupRelation.new
            groupofint.channel_id=@channel_id
            groupofint.group_id=groupx.id
          if groupofint.save
            puts "group association request sent"
          end
            end

          end
      end
  end

end
