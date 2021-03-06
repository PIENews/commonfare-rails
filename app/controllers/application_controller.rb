class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # before_action :set_gettext_locale
  before_action :set_locale
  before_action :set_globalize_fallbacks
  # before_action :authenticate_user!

  authorize_resource unless: :should_skip_authorization?
  check_authorization unless: :should_skip_authorization?

  layout :layout_by_resource

  rescue_from CanCan::AccessDenied do |exception|
    if current_user.nil?
      # Store the original requests
      if is_comment_creation?
        # binding.pry
        session[:comment_request_params] = request.request_parameters
        session[:comment_path_params] = request.path_parameters
      end
      redirect_to new_user_session_path, notice: _("You have to log in to continue")
    else
      if is_viewing_wallet?
        # redirects to the normal wallet_path if the wallet's currency is not in QR_CODE_ENABLED_CURRENCIES
        redirect_to commoner_wallet_path(@commoner, @wallet) # ... so ability is checked again
      elsif request.env["HTTP_REFERER"].present?
        redirect_back fallback_location: root_path
      else
        redirect_to root_url, alert: exception.message
      end
    end
  end

  # Devise wants this method here, see:
  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-after-a-successful-sign-in-or-sign-out
  def after_sign_in_path_for(resource)
    if resource.is_a? AdminUser
      admin_root_path
    else
      if comment_in_session?
        create_comment_from_session # This returns a path
      else
        commoner_path(current_user.meta)
      end
    end
  end

  def set_locale
    I18n.locale = params[:locale] || get_browser_locale || I18n.default_locale
  end

  def default_url_options(options = {})
    # Passing the locale in the URL when inside the admin interface is a mess
    # if self.class.ancestors.include?(ActiveAdmin::BaseController)
    #   options
    # else
      { locale: I18n.locale }.merge options
    # end
  end

  protected

  # Check if there is a comment in the session, i.e. the user tried to create a
  # Comment when not logged in.
  def comment_in_session?
    session[:comment_request_params].present? && session[:comment_path_params].present?
  end

  # Create a Comment in case the user started the comment creation
  # when not logged in, and return a path
  def create_comment_from_session
    if session[:comment_path_params]['story_id'].present?
      commentable = Story.friendly.find session[:comment_path_params]['story_id']
    elsif session[:comment_path_params]['listing_id'].present?
      commentable = Listing.friendly.find session[:comment_path_params]['listing_id']
    else
      commentable = nil
    end
    comment = commentable.comments.build(session[:comment_request_params]['comment'])
    comment.commoner = current_user.meta
    if comment.save
      # clear session
      clear_session
      # and go to the story or listing
      flash[:notice] = _('Comment was successfully created.')
      get_commentable_path(commentable)
    else
      flash[:alert] = _("A problem occurred with your comment. Please try again")
      get_commentable_path(commentable)
    end

  end

  # Associate an existing commoner to an existing QR enabled wallet
  # by manually acting on models and associations
  def associate_commoner_to_wallet(commoner, wallet)
    # 1. get the customer of the wallet
    customer = wallet.walletable
    # 2. get the group of the wallet
    group = wallet.currency.group
    # 3. give the wallet to the commoner
    wallet.walletable = commoner
    wallet.save
    # 4. remove the customer from the group by destroying the membership
    old_membership = Membership.find_by(commoner: customer, group: group)
    old_membership.destroy
    # 5. add the commoner to the group by creating the new membership, without creating a new wallet
    new_membership = Membership.create(commoner: commoner, group: group, role: 'affiliate')
    # 6. destroy the customer
    customer.destroy
  end

  # Delete all the keys in the session hash that have been used for
  # storing temporary data
  def clear_session
    session.delete :comment_request_params
    session.delete :comment_path_params
    session.delete :hash_id
  end

  private

  def layout_by_resource
    if devise_controller? && resource.is_a?(AdminUser)
      'admin/application'
    else
      'application'
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    # here resource_or_scope is a :symbol!
    if resource_or_scope == :admin_user
      new_admin_user_session_path
    else
      root_path
    end
  end

  def should_skip_authorization?
    devise_controller? ||
      is_a?(::PagesController) ||
      is_a?(::MainController) ||
      is_a?(::ExceptionHandler::ExceptionsController) ||
      is_a?(::ActivityNotification::NotificationsController)
      # admin_controller?
  end

  def set_globalize_fallbacks
    Globalize.fallbacks = {
      en: %i[en it nl hr],
      it: %i[it en nl hr],
      nl: %i[nl en it hr],
      hr: %i[hr en it nl],
    }
  end

  def get_browser_locale
    locale = browser&.accept_language&.first&.code&.to_sym
    I18n.available_locales.include?(locale) ? locale : nil
  end

  # Returns true if there has been a POST request for creating a Comment
  def is_comment_creation?
    request.post? && request.request_parameters['comment'].present?
  end

  def is_viewing_wallet?
    return false unless (params['controller'] == 'wallets' && params['action'] == 'view')
    @commoner = params['commoner_id']
    @wallet = params['id']
    true
  end

  def get_commentable_path(commentable)
    if commentable.is_a? Story
      story_path(commentable)
    elsif commentable.is_a? Listing
      listing_path(commentable)
    else
      root_path
    end
  end
end
