Gem::Specification.new do |s|
  s.name        = "wheelhouse-blog"
  s.platform    = Gem::Platform::RUBY
  s.version     = "1.0"
  s.summary     = "Wheelhouse Blog Plugin"
  s.description = "Blog plugin for Wheelhouse CMS."

  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"
  
  s.author   = "Sam Pohlenz"
  s.email    = "info@wheelhousecms.com"
  s.homepage = "https://www.wheelhousecms.com"
  
  s.files        = Dir["{app,config,lib}/**/*", "README.md"]
  s.require_path = "lib"
  
  s.add_dependency("wheelhouse", "~> 1.0")
end
