class ApplicationController < ActionController::Base
  # for pagination
  include Pagy::Backend
  
  before_action :set_social_links
  before_action :set_locale
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token
  before_action :set_main_services
  # before_action :set_services

  #jobs
  before_action :run_update_status_event_job
  
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

    def set_social_links
      url = WebConfig.first
      @social_links = [
        { link: url&.url_facebook,  name: 'facebook',   icon: 'ico-facebook.svg'  },
        { link: url&.url_instagram, name: 'instagram',  icon: 'ico-instagram.svg' },
        { link: url&.url_twitter,   name: 'twitter',    icon: 'ico-twitter.svg'   },
        { link: url&.url_pinterest, name: 'pinterest',  icon: 'ico-pinteres.svg'  },
        { link: url&.url_bodas_net, name: 'bodas_net',  icon: 'ico-bodasnet.svg'  },
      ]
    end

    
  def run_update_status_event_job
    Cadmin::UpdateStatusEventJob.set(wait: 1.day).perform_later(@events)
  end

  def get_opinions_from_bodasnet 
    url = 'https://www.bodas.net/musica/la-gramola-discotecas-moviles--e15600/opiniones'
    ScrapeOpinionsJob.set(wait: 1.day).perform_later(url)
  end
end
