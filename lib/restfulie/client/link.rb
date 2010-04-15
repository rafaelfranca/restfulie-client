module Restfulie::Client::HTTP

  # Offer easy access to Atom link relationships, such as <tt>post.next</tt> for 
  # <tt>&lt;link rel="next" href="http://resource.entrypoint.com/post/12" type="application/atom+xml" /&gt;</tt> relationships.
  module LinkShortcut
    def method_missing(method_sym,*args)#:nodoc:
      selected_links = links.select{ |l| l.rel == method_sym.to_s }
      super if selected_links.empty?
      link = (selected_links.size == 1) ? selected_links.first : selected_links
    
      return link unless link.instance_variable_defined?(:@type)
      link.accepts(link.type)
    
      representation = Restfulie::Client::HTTP::RequestMarshaller.content_type_for(link.type)
      return representation.prepare_link_for(link) if representation
      link

    end
  end

end
