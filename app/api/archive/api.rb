require 'grape'

module Archive
  class API < Grape::API
  	format :json

  	helpers do
      def current_user
        @current_user ||= User.first
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    resource :page_not_found do
      get do
        { error: 'page not found' }
      end
    end

    resource :pages do
      resource :published do   
    	  get do
    	  	authenticate!
    	  	Page.where("published_on IS NOT NULL OR published_on <= ?", Time.now).order("published_on DESC")
    	  end
      end

      resource :unpublished do
        get do
          authenticate!
          Page.where("published_on IS NULL OR published_on > ?", Time.now).order("published_on DESC")
        end
      end


      get do
        authenticate!
        @page = current_user.page
      end

      post do
        authenticate!
        @post = Page.create(params[:page])
        if @post.save
          { success: true }
        else
          { error: 'error with save page' }
        end
      end

      get ':id' do
        authenticate!
        @page = Page.find_by_id(params[:id])
        if @page
          @page
        else
          redirect '/api/page_not_found' 
        end
      end

      put ':id' do
        authenticate!
        @page = Page.find_by_id(params[:id])
        if @page
          if @page.update_attributes(params[:page])
            { success: true }
          else
            { error: 'error with update' }
          end
        else
          redirect '/api/page_not_found'
        end
      end

      delete ':id' do
        authenticate!
        @page = Page.find_by_id(params[:id])
        if @page
          if @page.destroy
            { success: true }
          else
            { error: 'error with destroy' }
          end
        else
          redirect '/api/page_not_found'
        end
      end


      post ':id/published' do
        authenticate!
        @page = Page.find_by_id(params[:id])
        if @page
          if @page.update_attributes(published_on: Time.now)
            { success: true }
          else
            { error: 'error with save' }
          end
        else
          redirect '/api/page_not_found'
        end
      end

      get ':id/total_words' do
        authenticate!
        @page = Page.find_by_id(params[:id])
        if @page
          { count: "#{@page.title} #{@page.content}".split.count }
        else
          redirect '/api/page_not_found'
        end
      end
  	end	
  end
end