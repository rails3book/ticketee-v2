module ApplicationHelper
  def title(*parts)
    unless parts.empty?
      content_for :title do
        (parts << "Ticketee").join(" - ") unless parts.empty?
      end
    end
  end

  def admins_only(&block)
    concat(block.call) if current_user.try(:admin?)
  end

  def authorized?(permission, thing, &block)
    concat(block.call) if can?(permission.to_sym, thing) ||
                          current_user.try(:admin?)
  end
end
