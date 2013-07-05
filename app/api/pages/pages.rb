require 'grape'

module Pages
  class API < Grape::API
    format :json

    helpers do
      def current_user
        @current_user ||= User.find(params[:username])
      end      
    end

    resource :pages do
      resource :published do   
        get do
          Page.where("published_on IS NOT NULL OR published_on <= ?", Time.now).order("published_on DESC")
        end
      end

      resource :unpublished do
        get do
          Page.where("published_on IS NULL OR published_on > ?", Time.now).order("published_on DESC")
        end
      end


      get do
        @page = current_user.admin? ? Page.all : current_user.pages
      end

      post do
        @page = Page.create(params[:page])
        if @page.save
          { success: true }
        else
          error!('Page not save', 401)
        end
      end

      get ':id' do
        @page = Page.find_by_id(params[:id])
        if @page
          @page
        else
          error!('Page not found', 401)
        end
      end

      put ':id' do
        @page = Page.find_by_id(params[:id])
        if @page
          if @page.update_attributes(params[:page])
            { success: true }
          else
            error!('Page not found', 401)
          end
        else
          error!('Page not found', 401)
        end
      end

      delete ':id' do
        @page = Page.find_by_id(params[:id])
        if @page
          if @page.destroy
            { success: true }
          else
            error!('Page not found', 401)
          end
        else
          error!('Page not found', 401)
        end
      end


      post ':id/published' do
        @page = Page.find_by_id(params[:id])
        if @page
          if @page.update_attributes(published_on: Time.now)
            { success: true }
          else
            error!('Page not found', 401)
          end
        else
          error!('Page not found', 401)
        end
      end

      get ':id/total_words' do
        @page = Page.find_by_id(params[:id])
        if @page
          { count: "#{@page.title} #{@page.content}".split.count }
        else
          error!('Page not found', 401)
        end
      end
    end 
  end
end