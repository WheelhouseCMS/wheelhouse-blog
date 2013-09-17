class Blog::BlogHandler < Wheelhouse::ResourceHandler
  extend Blog::WheelhouseRouteConstraints
  
  get "/(page/:page)", :cache => true, :page => /\d+/ do
    @posts = paginate(@blog.posts)
  end

  get "/feed.xml", :cache => true do
    render :template => "feed", :formats => [:rss], :layout => false
  end
  
  get '/tag/:tag(/page/:page)', :cache => true, :page => /\d+/ do
    @posts = paginate(@blog.posts.tagged_with(params[:tag]))
    render :template => "tag"
  end
  
  get '/category/:category(/page/:page)', :cache => true, :page => /\d+/ do
    @posts = paginate(@blog.posts.in_category(params[:category]))
    render :template => "category"
  end
  
  get "/:year(/:month)(/page/:page)", :cache => true, :year => /\d{4}/, :month => /\d\d?/, :page => /\d+/ do
    @archive = Blog::Archive.new(@blog, params[:year], params[:month].presence)
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}" if @archive.invalid?
    
    @posts = paginate(@archive.posts)
    render :template => "archive"
  end
  
  get "/:year/:month/:permalink", :cache => true, :year => /\d{4}/, :month => /\d\d?/ do
    @post = @blog.find_post(params[:year], params[:month], params[:permalink])
    render @post
  end
  
  post "/:year/:month/:permalink", :year => /\d{4}/, :month => /\d\d?/ do
    @post = @blog.find_post(params[:year], params[:month], params[:permalink])
    @comment = Blog::Comment.new(params[:comment])
    @post.submit_comment(@comment)
    
    render @post
  end

private
  def paginate(posts)
    posts.paginate(:page => params[:page].presence || 1, :per_page => @blog.posts_per_page)
  end
end
