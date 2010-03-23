module Restfulie::Client::HTTP::Marshal#:nodoc:

  #Custom request builder for marshalled data that unmarshalls content after receiving it.
  module RequestBuilder
    include ::Restfulie::Client::HTTP::RequestBuilder

    @raw = false

    #Tells Restfulie to return the raw content, instead of unmarshalling it.
    def raw
      @raw = true
      self
    end
    
    # executes super and unmarshalls it
    def request!(method, path, *args)
      response = super(method, path, *args)
      @raw ? Response::Raw.new(response) : response.unmarshal
    end
  end

  # Class responsible for unmarshalling a response
  class Response < ::Restfulie::Client::HTTP::Response
        
    @@marshals = {}

    ## 
    # :singleton-method:
    # Use to register marshals
    #
    # * <tt>media type</tt>
    # * <tt>marshall</tt>
    #
    #==Example:
    #
    #   module FakeMarshal
    #    def self.unmarshal(response)
    #     ...
    #    end
    #   end
    #   
    #   Restfulie::Client::HTTP::Marshal::Response.register('application/atom+xml',FakeMarshal)
    #
    def self.register(content_type,marshal)
      @@marshals[content_type] = marshal
    end

    #Unmarshal resonse's body according content-type header.
    #If no marshal registered will return Raw instance
    def unmarshal
      content_type = headers['Content-Type'] || headers['content-type']
      marshaller = @@marshals[content_type]
      return Raw.new(self) unless marshaller 
      unmarshaled = marshaller.unmarshal(self)
      unmarshaled.extend(ResponseHolder)
      unmarshaled.response = self
      unmarshaled
    end

    #Every unmarshaled response's body has an accessor to response
    module ResponseHolder
      attr_accessor :response
    end

    #If no marshaller is registered, Restfulie returns an instance of Raw
    class Raw
      attr_reader :response
      def initialize(response)
        @response = response
      end
    end

  end

end

Restfulie::Client::HTTP::ResponseHandler.register(200,Restfulie::Client::HTTP::Marshal::Response)

