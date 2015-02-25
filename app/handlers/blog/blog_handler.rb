class Blog::BlogHandler < Wheelhouse::ResourceHandler
  extend Blog::WheelhouseRouteConstraints
  
  get "/(page/:page)", :cache => true, :page => /\d+/ do
    @posts = paginate(@blog.posts.visible)
  end

  get "/feed.xml", :cache => true do
    render :template => "feed", :formats => [:rss], :layout => false
  end
  
  get '/tag/:tag(/page/:page)', :cache => true, :page => /\d+/ do
    @posts = paginate(@blog.posts.visible.tagged_with(params[:tag]))
    render :template => "tag"
  end
  
  get '/category/:category(/page/:page)', :cache => true, :page => /\d+/ do
    @posts = paginate(@blog.posts.visible.in_category(params[:category]))
    render :template => "category"
  end
  
  get "/:year(/:month)(/page/:page)", :cache => true, :year => /\d{4}/, :month => /\d\d?/, :page => /\d+/ do
    @archive = Blog::Archive.new(@blog, params[:year], params[:month].presence)
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}" if @archive.invalid?
    
    @posts = paginate(@archive.posts.visible)
    render :template => "archive"
  end
  
  get "/:year/:month/:permalink", :cache => true, :year => /\d{4}/, :month => /\d\d?/ do
    @post = @blog.find_post(params[:year], params[:month], params[:permalink])
    render @post
  end
  
  post "/:year/:month/:permalink", :year => /\d{4}/, :month => /\d\d?/ do
    @post = @blog.find_post(params[:year], params[:month], params[:permalink])
    @comment = Blog::Comment.new(comment_params)
    @post.comments.submit(@comment)
    
    render @post
  end

private
  def paginate(posts)
    posts.paginate(:page => params[:page].presence || 1, :per_page => @blog.posts_per_page)
  end
  
  def comment_params
    if params.respond_to?(:require)
      params.require(:comment).permit(:author, :email, :comment)
    else
      params[:comment]
    end
  end
end
