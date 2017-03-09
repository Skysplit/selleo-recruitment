class UserMailerPreview < ActionMailer::Preview
  def regards_mail
    to = User.new(email: 'to@example.com')
    from = User.new(email: 'from@example.com')
    UserMailer.regards_email(from, to)
  end
end
