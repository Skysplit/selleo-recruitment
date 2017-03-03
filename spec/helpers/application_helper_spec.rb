require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "flash message bootstrap alert component class" do
    it "should get error flash class" do
      expect(flash_bootstrap_class(:error)).to eq 'danger'
    end

    it "should get alert flash class" do
      expect(flash_bootstrap_class(:alert)).to eq 'warning'
    end

    it "should get notice flash class" do
      expect(flash_bootstrap_class(:notice)).to eq 'info'
    end

    it "should default to notice class" do
      expect(flash_bootstrap_class(:non_existing_flash_type)).to eq 'info'
    end
  end
end
