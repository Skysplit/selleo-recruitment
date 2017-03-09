class Admin::HomeController < Admin::ApplicationController
  def index
    @count = Interest.health.name_starts_with_cosm.belongs_to_women_between_20_and_30.count
  end
end
