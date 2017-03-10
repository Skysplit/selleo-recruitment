require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "regards_mail" do
    let(:user_to) { User.create email: 'to@example.com' }
    let(:user_from) { User.create email: 'from@example.com' }
    let(:mail) { UserMailer.regards_email(user_from, user_to) }

    it "should render the headers" do
      expect(mail.subject).to eq('You received regards!')
      expect(mail.to).to eq([user_to.email])
      expect(mail.from).to eq([user_from.email])
    end

    it "should render the body" do
      expect(mail.body.encoded).to match(user_from.email)
      expect(mail.body.encoded).to match(user_to.email)
      expect(mail.body.encoded).to match('sends his regards')
    end
  end
end
