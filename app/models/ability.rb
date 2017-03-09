class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :destroy, :all
      can :admin, :all
      cannot :destroy, User, id: user.id
    end
  end
end
