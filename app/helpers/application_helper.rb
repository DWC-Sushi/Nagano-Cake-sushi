module ApplicationHelper

  def after_sign_in_path_for(resource)
     public_customer_path
  end
end
