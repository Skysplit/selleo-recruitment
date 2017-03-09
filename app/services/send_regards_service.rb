class SendRegardsService
  def initialize(mailer, from, to)
    @mailer = mailer
    @from = from
    @to = to
  end

  def call
    construct_mail.deliver_now
  end

  private

  def construct_mail
    @mailer.regards_email(@from, @to)
  end
end
