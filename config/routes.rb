Blog::Plugin.routes.draw do
  extend Wheelhouse::RouteExtensions
  
  resources :blogs do
    resources :posts do
      resources :comments
    end
  end
end
