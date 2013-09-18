Blog::Plugin.routes.draw do
  extend Wheelhouse::RouteExtensions
  
  resources :blogs do
    resources :posts do
      resources :comments do
        member do
          post :moderate
        end
      end
    end
  end
end
