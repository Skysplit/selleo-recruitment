module ApplicationHelper
  def flash_bootstrap_class(type)
    case type.to_sym
    when :error
      "danger"
    when :alert
      "warning"
    else
      "info"
    end
  end
end
