class Place < ActiveRecord::Base
  belongs_to :user
  attr_readonly :created_at
  geocoded_by :address
  acts_as_gmappable :latitude =>'latitude', :longitude =>'longitude',
                    :msg => "casino meda"

  def gmaps4rails_infowindow

    "<h4>#{name}</h4>" << "<h4>Latitude: #{latitude}</h4>" << "<h4>Longitude: #{longitude}</h4>"

  end
  def gmaps4rails_title
    "#{name}"# add here whatever text you desire
  end
  def gmaps4rails_sidebar
    name
  end


end
