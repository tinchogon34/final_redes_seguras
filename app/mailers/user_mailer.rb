class UserMailer < ActionMailer::Base
  default from: "no-reply@codingways.com.ar"

  def confirmation_email(user)
    @user = user
    @url  = "https://martin-gonzalez.codingways.com/users/confirm?email=#{@user.email}&token=#{@user.confirm_token}"
    mail(to: @user.email, subject: 'Confirme su registro')
  end
end
