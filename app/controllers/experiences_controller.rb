class ExperiencesController < ApplicationController
    def new
        @experience = Experience.new
    end
    
    def create
        Experience.create(:experience => params[:experience][:experience], :rating => params[:experience][:rating], :user_id => session[:user], :program_id => params[:id])
        redirect_to portal_path(params[:id])
    end
    
    
    def create_comment
        ExperienceComment.create(:comment => params[:commentText], :rating => params[:rating], :user_id => session[:user], :experience_id => params[:experienceId])
        @experience = Experience.left_outer_joins(:user).select("experiences.*,users.name as user_name").where(experiences: {id: params[:experienceId]}).first
        
        @experience.comments = ExperienceComment.left_outer_joins(:user).select("experience_comments.*,users.name as user_name").where(experience_id: params[:experienceId]).order(created_at: :desc)
        
        rating_sum = ExperienceComment.where(experience_id: params[:experienceId]).group(:experience_id).sum(:rating).values[0]
        rating_sum += @experience.rating #add the original rating
        rating_count = ExperienceComment.where(experience_id: params[:experienceId]).where.not(rating: nil).count(:id)
        rating_count +=1 #add 1 for the original rating
        @experience.average_rating = (rating_sum.to_f / rating_count).round(1)
        
        @experienceDivId = "portal-experience-wrapper-" + params[:experienceId]
        
        respond_to do |format|
            format.js {}
        end
    end
end
