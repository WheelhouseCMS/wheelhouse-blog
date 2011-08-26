# This handler is only used for post previewing
class Blog::PostHandler < Wheelhouse::ResourceHandler
  get do
    self.node = @post.blog
    render @post
  end
end
