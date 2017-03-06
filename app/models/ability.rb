class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.admin?
      can :crud, :all
      cannot :destroy, User, id: user.id
    end
  end
end
