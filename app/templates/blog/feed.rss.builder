xml.instruct!

xml.rss :version => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.title site.name
    xml.description @blog.title
    xml.link url(@blog)
    xml.tag! 'atom:link', :href => request.url, :rel => 'self', :type => 'application/rss+xml'

    @blog.posts.each do |post|
      xml.item do
        xml.title post.title
        xml.author "#{post.author.email} (#{post.author.name})"
        xml.pubDate post.published_at.to_s(:rss)

        xml.description do
          xml.cdata!(post.content.to_s)
        end
        
        post.categories.each do |category|
          xml.category do
            xml.cdata!(category)
          end
        end
         
        xml.link url(post)
        xml.guid url(post)
        
        xml.comments url(post.comments_path) if blog.comments_enabled?
      end
    end
  end
end
