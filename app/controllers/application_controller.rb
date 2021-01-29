class ApplicationController < ActionController::Base
    def authorize_admin!
        unless current_user.admin?
        flash[:alert] = "You must be a editor in to access this section"
        redirect_to new_user_session_url
        end
    end
end
