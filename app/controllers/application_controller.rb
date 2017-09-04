class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_gettext_locale
  before_action :set_locale
  # before_action :authenticate_user!

  authorize_resource unless: :should_skip_authorization?
  check_authorization unless: :should_skip_authorization?

  # Devise wants this method here, see:
  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-after-a-successful-sign-in-or-sign-out
  def after_sign_in_path_for(resource)
    commoner_path(current_user.meta)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    # Passing the locale in the URL when inside the admin interface is a mess
    # if self.class.ancestors.include?(ActiveAdmin::BaseController)
    #   options
    # else
      { locale: I18n.locale }.merge options
    # end
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    # here resource_or_scope is a :symbol!
    root_path
  end

  def should_skip_authorization?
    devise_controller? # ||
      # admin_controller? ||
      # is_a?(::PagesController) ||
      # is_a?(::ReportsController) # ReportsController has manual authorization in place because it is not RESTful
  end
end
