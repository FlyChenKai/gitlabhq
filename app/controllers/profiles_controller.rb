class ProfilesController < Profiles::ApplicationController
  include ActionView::Helpers::SanitizeHelper

  before_action :user
  before_action :authorize_change_username!, only: :update_username
  skip_before_action :require_email, only: [:show, :update]

  def show
  end

  def update
    respond_to do |format|
      result = Users::UpdateService.new(current_user, user_params.merge(user: @user)).execute

      if result[:status] == :success
        message = "Profile was successfully updated"

        p '😂'

        format.html do
          p '😘'
          redirect_back_or_default(default: { action: 'show' }, options: { notice: message })
        end
        format.json do
          p '🙄'
          render json: { message: message }
        end
      else
        format.html { redirect_back_or_default(default: { action: 'show' }, options: { alert: result[:message] }) }
        format.json { render json: result }
      end
    end
  end

  def reset_incoming_email_token
    Users::UpdateService.new(current_user, user: @user).execute! do |user|
      user.reset_incoming_email_token!
    end

    flash[:notice] = "Incoming email token was successfully reset"

    redirect_to profile_personal_access_tokens_path
  end

  def reset_rss_token
    Users::UpdateService.new(current_user, user: @user).execute! do |user|
      user.reset_rss_token!
    end

    flash[:notice] = "RSS token was successfully reset"

    redirect_to profile_personal_access_tokens_path
  end

  def audit_log
    @events = AuditEvent.where(entity_type: "User", entity_id: current_user.id)
      .order("created_at DESC")
      .page(params[:page])
  end

  def update_username
    result = Users::UpdateService.new(current_user, user: @user, username: user_params[:username]).execute

    options = if result[:status] == :success
                { notice: "Username successfully changed" }
              else
                { alert: "Username change failed - #{result[:message]}" }
              end

    redirect_back_or_default(default: { action: 'show' }, options: options)
  end

  private

  def user
    @user = current_user
  end

  def authorize_change_username!
    return render_404 unless @user.can_change_username?
  end

  def user_params
    @user_params ||= params.require(:user).permit(
      :avatar,
      :bio,
      :email,
      :hide_no_password,
      :hide_no_ssh_key,
      :hide_project_limit,
      :linkedin,
      :location,
      :name,
      :password,
      :password_confirmation,
      :public_email,
      :skype,
      :twitter,
      :username,
      :website_url,
      :organization,
      :preferred_language,
      :webpush_endpoint,
      :webpush_p256dh,
      :webpush_auth,
      :subscribed_pipeline
    )
  end
end
