# RailsAdmin config file. Generated on January 18, 2013 16:48
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|


  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Siot', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user_admin } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, 'UserAdmin'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'UserAdmin'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['ApiKey', 'Channel', 'Feed', 'Place', 'Relationship', 'User']

  # Include specific models (exclude the others):
  # config.included_models = ['ApiKey', 'Channel', 'Feed', 'Place', 'Relationship', 'User']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:



  ###  ApiKey  ###

  # config.model 'ApiKey' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your api_key.rb model definition

  #   # Found associations:

  #     configure :channel, :belongs_to_association 
  #     configure :user, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :api_key, :string 
  #     configure :channel_id, :integer         # Hidden 
  #     configure :user_id, :integer         # Hidden 
  #     configure :write_flag, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :note, :string 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Channel  ###

  # config.model 'Channel' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your channel.rb model definition

  #   # Found associations:

  #     configure :user, :belongs_to_association 
  #     configure :feeds, :has_many_association 
  #     configure :api_keys, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :user_id, :integer         # Hidden 
  #     configure :name, :string 
  #     configure :description, :string 
  #     configure :field1, :string 
  #     configure :field2, :string 
  #     configure :field3, :string 
  #     configure :field4, :string 
  #     configure :field5, :string 
  #     configure :field6, :string 
  #     configure :field7, :string 
  #     configure :field8, :string 
  #     configure :field9, :string 
  #     configure :field10, :string 
  #     configure :field11, :string 
  #     configure :field12, :string 
  #     configure :field13, :string 
  #     configure :field14, :string 
  #     configure :field15, :string 
  #     configure :field16, :string 
  #     configure :scale1, :integer 
  #     configure :scale2, :integer 
  #     configure :scale3, :integer 
  #     configure :scale4, :integer 
  #     configure :scale5, :integer 
  #     configure :scale6, :integer 
  #     configure :scale7, :integer 
  #     configure :scale8, :integer 
  #     configure :scale9, :integer 
  #     configure :scale10, :integer 
  #     configure :scale11, :integer 
  #     configure :scale12, :integer 
  #     configure :scale13, :integer 
  #     configure :scale14, :integer 
  #     configure :scale15, :integer 
  #     configure :scale16, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :last_entry_id, :integer 
  #     configure :public_flag, :boolean 
  #     configure :options1, :string 
  #     configure :options2, :string 
  #     configure :options3, :string 
  #     configure :options4, :string 
  #     configure :options5, :string 
  #     configure :options6, :string 
  #     configure :options7, :string 
  #     configure :options8, :string 
  #     configure :options9, :string 
  #     configure :options10, :string 
  #     configure :options11, :string 
  #     configure :options12, :string 
  #     configure :options13, :string 
  #     configure :options14, :string 
  #     configure :options15, :string 
  #     configure :options16, :string 
  #     configure :model, :string 
  #     configure :brand, :string 
  #     configure :device_type, :string 
  #     configure :mobility_status, :boolean 
  #     configure :location, :integer 
  #     configure :location_name, :string
  #     configure :location_type, :integer 
  #     configure :oor_flag, :boolean 
  #     configure :por_flag, :boolean 
  #     configure :cwor_flag, :boolean 
  #     configure :sor_flag, :boolean 
  #     configure :clor_flag, :boolean 
  #     configure :bt_mac_address, :string
  #     configure :wf_mac_address, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Feed  ###

  # config.model 'Feed' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your feed.rb model definition

  #   # Found associations:

  #     configure :channel, :belongs_to_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :channel_id, :integer         # Hidden 
  #     configure :raw_data, :text 
  #     configure :field1, :string 
  #     configure :field2, :string 
  #     configure :field3, :string 
  #     configure :field4, :string 
  #     configure :field5, :string 
  #     configure :field6, :string 
  #     configure :field7, :string 
  #     configure :field8, :string 
  #     configure :field9, :string 
  #     configure :field10, :string 
  #     configure :field11, :string 
  #     configure :field12, :string 
  #     configure :field13, :string 
  #     configure :field14, :string 
  #     configure :field15, :string 
  #     configure :field16, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :entry_id, :integer 
  #     configure :status, :string 


  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Place  ###

  # config.model 'Place' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your place.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :address, :string 
  #     configure :creator_id, :integer
  #     configure :latitude, :float
  #     configure :longitude, :float
  #     configure :range, :integer 
  #     configure :public, :boolean 
  #     configure :home, :boolean 
  #     configure :work, :boolean 
  #     configure :gmaps, :boolean 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Relationship  ###

  # config.model 'Relationship' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your relationship.rb model definition

  #   # Found associations:

  #     configure :users, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :guid_one, :integer 
  #     configure :relation, :string 
  #     configure :guid_two, :integer 
  #     configure :time_created, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  User  ###

  # config.model 'User' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition

  #   # Found associations:

  #     configure :channels, :has_many_association 
  #     configure :api_keys, :has_many_association 

  #   # Found columns:

  #     configure :id, :integer 
  #     configure :login, :string 
  #     configure :email, :string 
  #     configure :crypted_password, :string 
  #     configure :password_salt, :string 
  #     configure :persistence_token, :string 
  #     configure :perishable_token, :string 
  #     configure :current_login_at, :datetime 
  #     configure :last_login_at, :datetime 
  #     configure :current_login_ip, :string 
  #     configure :last_login_ip, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :time_zone, :string 
  #     configure :home_location, :string 
  #     configure :work_place, :string 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end

end
