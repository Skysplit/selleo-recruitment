module ApplicationHelper
  def flash_bootstrap_class(type)
    case type
    when :error
      "danger"
    when :alert
      "warning"
    else
      "info"
    end
  end
end
