class Mailer < ActionMailer::Base
	#default :from => 'siot@diee.unica.it'

  def password_reset(user, webpage)
		@user = user
		@webpage = webpage
		mail(:to => @user.email,
			:subject => t(:password_reset_subject),
      :from => "siot@diee.unica.it")
	end

end
