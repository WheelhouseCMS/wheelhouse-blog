module Blog
  module WheelhouseRouteConstraints
    # Fixes handler route definitions in Wheelhouse 1.0 (fixed in 1.1) to allow
    # route constraints to be set (e.g. match route segments to a regex).
    def define_action(path, action_name, method, options={}, &block)
      define_method(action_name, &block)
      _mapper.match(path, { :via => method, :to => action(action_name) }.merge(options))
      
      caches_page(action_name) if options[:cache]
    end
  end
end
