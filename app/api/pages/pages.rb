require 'grape'

module Pages
  class API < Grape::API
    format :json

    helpers do
      def current_user
        @current_user ||= User.find_by_username(params['username'])
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end      
    end

    resource :pages do
      resource :published do   
        get do
          authenticate!
          @pages = current_user.admin? ? Page.published.desc : current_user.pages.published.desc
        end
      end

      resource :unpublished do
        get do
          authenticate!
          @pages = current_user.admin? ? Page.unpublished.desc : current_user.pages.unpublished.desc
        end
      end


      get do
        authenticate!
        @pages = current_user.admin? ? Page.desc : current_user.pages.desc
      end

      post do
        authenticate!
        @page = Page.create({ title: params[:page][':title'], 
                              content: params[:page][':content'], 
                              user_id: current_user.id })
        if @page.save
          { success: true }
        else
          error!('Page not save', 401)
        end
      end

      get ':id' do
        authenticate!
        @page = Page.find_by_id(params[:id])
        if @page
          @page
        else
          error!('Page not found', 401)
        end
      end

      put ':id' do
        authenticate!
        @page = Page.find_by_id(params[:id])
        if @page
          if @page.update_attributes({ title: params[:page][':title'], 
                                       content: params[:page][':content'] })
            { success: true }
          else
            error!('Page not found', 401)
          end
        else
          error!('Page not found', 401)
        end
      end

      delete ':id' do
        authenticate!
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
        authenticate!
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
        authenticate!
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