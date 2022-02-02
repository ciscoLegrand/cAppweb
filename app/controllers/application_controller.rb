class ApplicationController < ActionController::Base
  # for pagination
  include Pagy::Backend
 
  before_action :set_locale
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token
  before_action :set_main_services
  # before_action :set_services
  


  protected
    def set_locale
      # if cadmin_user_signed_in?
      #   I18n.locale = current_cadmin_user.language # TODO: ADD TO CADMIN USER LANGUAGE FIELD TO SET THE LANGUAGE
      # else
        I18n.locale = params[:lang] || locale_from_header || I18n.default_locale
      # end
    end
    def locale_from_header
      request.env.fetch('HTTP_ACCEPT_LANGUAGE','').scan(/[a-z]{2}/).first
    end
    def set_main_services
      @main_services =  Cadmin::MainService.all 
    end  

    def set_services
      @services = Cadmin::Service.all
    end
end
