Blog::Plugin::Routes.draw do
  namespace :admin, :module => :blog, :as => :blog do
    resources :blogs do
      resources :posts
    end
  end
end
