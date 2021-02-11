class Users::InvitationsController < Devise::InvitationsController

  before_action :update_sanitized_params

  if respond_to? :helper_method
    helper_method :after_sign_in_path_for
  end

  def mirror_new
    self.resource = resource_class.new
    resource.email = current_user.mirroring_requests_for_user.find(params[:id]).email
    if !resource.email.nil?
      alerts = current_user.alerts.where(:alert_type => 'Mirroring request', :alert_name => resource.email, :user_id => current_user.id, :organization_id => current_user.organization.orgid)
      alerts.update_all(:status => true)
      render :mirror_new
    else
      flash[:alert] = "The mirroring request could not be accepted."
      redirect_to :myorg
    end
  end

  def edit
    if resource.status
      set_minimum_password_length
      resource.invitation_token = params[:invitation_token]
      render :edit
    else
      flash[:alert] = "The invitation token provided is not valid!"
      redirect_to(root_path)
    end
  end

  # PUT /resource/invitation
  def update
    raw_invitation_token = update_resource_params[:invitation_token]
    self.resource = accept_resource
    invitation_accepted = resource.errors.empty?

    yield resource if block_given?

    if invitation_accepted
      if resource.class.allow_insecure_sign_in_after_accept
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message :notice, flash_message if is_flashing_format?
        resource.after_database_authentication
        sign_in(resource_name, resource)
        respond_with resource, location: after_accept_path_for(resource)
      else
        set_flash_message :notice, :updated_not_active if is_flashing_format?
        respond_with resource, location: new_session_path(resource_name)
      end
    else
      resource.invitation_token = raw_invitation_token
      respond_with_navigational(resource) { render :edit }
    end
  end

  private
  # this is called when creating invitation
  # should return an instance of resource class
  def invite_resource
    new_user = User.new(:email => resource_params[:email],:organization_id => resource_params[:organization_id],:role_ids => resource_params[:role_ids])
    new_user.password = new_user.random_password
    new_user.udf_allowed_value_ids = [-1]
    mirroring_requests = new_user.organization.mirroring_requests.where(:email => new_user.email)
    if mirroring_requests.count > 0
      new_user.is_mirrored_user = true
      if new_user.save
        flash[:notice] = "New user has been created "
        mirroring_requests.update_all(:status => 'Approved')
      else
        mirroring_requests.update_all(:status => nil)
        flash[:alert] = "New user could not be created"
      end
    else
      if new_user.save
        new_user.invite!(current_user)
        flash[:notice] = t('devise.invitations.send_instructions', {:email => new_user.email})
      end
    end
    new_user
  end

  # Redirect path for after invitation
  def after_invite_path_for(inviter, invitee)
    if policy(:user).edit? && !invitee.is_mirrored_user
      edit_profile_path(invitee)
    else
      myorg_path
    end
  end

  # this is called when accepting invitation
  # should return an instance of resource class
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
  end

  protected
  def resource_from_invitation_token
    unless params[:invitation_token] && self.resource = resource_class.find_by_invitation_token(params[:invitation_token], true)
      set_flash_message(:alert, :invitation_token_invalid) if is_flashing_format?
      sign_out
      redirect_to after_sign_out_path_for(resource_name)
    end
  end

  def invite_params
    devise_parameter_sanitizer.sanitize(:invite)
  end

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name, :password, :password_confirmation, :invitation_token])
  end
end