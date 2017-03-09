class UserMailer < ApplicationMailer
  def regards_email(from, to)
    @from = from
    @to = to
    mail(to: to.email, from: from.email, subject: 'You received regards!')
  end
end
