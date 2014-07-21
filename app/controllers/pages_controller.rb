class PagesController < ApplicationController

	def home
		@menu = 'home'
	end

  def user_guide
    @menu = 'user_guide'
  end

  def developer_guide
    @menu = 'developer_guide'
  end
end
