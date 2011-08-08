Blog::Plugin.routes.draw do
  extend Wheelhouse::RouteExtensions
  
  resources :blogs do
    resources :posts
  end
end
