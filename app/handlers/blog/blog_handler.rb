class Blog::BlogHandler < Wheelhouse::ResourceHandler
  helper Blog::BlogHelper
  
  get :cache => true do
    # Nothing extra required
  end

  get "/feed.xml", :cache => true do
    request.format = :xml
    render :template => "feed.xml", :layout => false
  end
  
  get '/tag/:tag', :cache => true do
    @posts = @blog.posts.tagged_with(params[:tag])
    render :template => "tag.html"
  end
  
  get '/category/:category', :cache => true do
    @posts = @blog.posts.in_category(params[:category])
    render :template => "category.html"
  end
  
  get "/:year/:month/:permalink", :cache => true do
    @post = @blog.find_post(params[:year], params[:month], params[:permalink])
    render @post
  end
  
  get "/:year/:month", :cache => true do
    @year  = params[:year].to_i
    @month = params[:month].to_i
    raise ActionController::RoutingError, "No route matches #{request.original_path.inspect}" if @year.zero? || @month.zero?
    
    @posts = @blog.posts.in_year_and_month(@year, @month)
    render :template => "archive.html"
  end
end
