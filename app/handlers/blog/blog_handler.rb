class Blog::BlogHandler < Wheelhouse::ResourceHandler
  get "/(page/:page)", :cache => true do
    @posts = paginate(@blog.posts)
  end

  get "/feed.xml", :cache => true do
    request.format = :xml
    render :template => "feed", :formats => [:xml], :layout => false
  end
  
  get '/tag/:tag(/page/:page)', :cache => true do
    @posts = paginate(@blog.posts.tagged_with(params[:tag]))
    render :template => "tag"
  end
  
  get '/category/:category(/page/:page)', :cache => true do
    @posts = paginate(@blog.posts.in_category(params[:category]))
    render :template => "category"
  end
  
  get "/:year/:month/:permalink", :cache => true do
    @post = @blog.find_post(params[:year], params[:month], params[:permalink])
    render @post
  end
  
  get "/:year/:month(/page/:page)", :cache => true do
    @year  = params[:year].to_i
    @month = params[:month].to_i
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}" if @year.zero? || @month.zero?
    
    @posts = paginate(@blog.posts.in_year_and_month(@year, @month))
    render :template => "archive"
  end

private
  def paginate(posts)
    posts.paginate(:page => params[:page].presence || 1, :per_page => @blog.posts_per_page)
  end
end
