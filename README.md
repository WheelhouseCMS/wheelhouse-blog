Blog Plugin for Wheelhouse CMS
==============================

![Screenshot of blog plugin](https://www.wheelhousecms.com/media/308e77b2/Blog-Plugin.png)

This gem makes it easy to integrate a blog or news feed into your Wheelhouse CMS site.

It currently supports:

- RSS feed
- tags
- categories
- archives
- pagination
- multiple blogs

It does not yet support commenting but this will be implemented in the near future. In the meanwhile, it is fairly easy to integrate comments using a third-party JavaScript library such as [Disqus](http://disqus.com/) or [Facebook Comments](https://developers.facebook.com/docs/reference/plugins/comments/).


Installation & Usage
--------------------

**1. Add `wheelhouse-blog` to your Gemfile:**

    gem "wheelhouse-blog"

Then run `bundle install`.

**2. Create a new blog from the New Page dropdown.**

**3. To customize, copy the partials (`_post.html.haml` and `_layout.html.haml`) from `app/templates/blog` to your theme templates folder.**
