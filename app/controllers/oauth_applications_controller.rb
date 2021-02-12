# frozen_string_literal: true

class OauthApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_application, only: %i[show edit update destroy]

  def index
    @applications = OauthApplication.all.order(:created_at)
  end

  def show
  end

  def new
    @application = current_user.oauth_applications.new
  end

  def create
    @application = current_user.oauth_applications.new(application_params)

    if @application.save
      flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications create])
      redirect_to oauth_application_url(@application)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @application.update(application_params)
      flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications update])
      redirect_to oauth_application_url(@application)
    else
      render :edit
    end
  end

  def destroy
    if @application.destroy
      flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications destroy])
    end

    redirect_to oauth_applications_url
  end

  private

    def set_application
      @application = OauthApplication.find(params[:id].to_i)
    end

    def application_params
      params.require(:doorkeeper_application).permit(:name, :url, :redirect_uri, :scopes, :confidential)
    end

    def check_admin
      if !current_user.cc_admin
        redirect_to '/'
      end
    end
end
