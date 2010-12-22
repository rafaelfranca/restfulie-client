module Restfulie
  module Common
    module Converter
      module Xml
        
        # an object to represent a list of links that can be invoked
        class Links
          
          def initialize(links)
            links = [links] unless links.kind_of? Array
            links = [] unless links
            @links = links.map { |l| Restfulie::Common::Converter::Xml::Link.new(l) }
          end
          
          def method_missing(sym, *args)
            @links.find do |link|
              link.rel == sym.to_s
            end
          end
        end
      end
    end
  end
end
