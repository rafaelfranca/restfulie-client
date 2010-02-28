require 'net/http'
require 'uri'

# TODO Remove this after remove Media Types (if need?)
require 'rubygems'
require 'active_support'
require 'action_controller'

require 'atom'


require 'vendor/jeokkarak/jeokkarak'

#initialize namespace
module Restfulie; end
module Restfulie::Common; end

%w(
  logger
  media_type
  unmarshalling
  restfulie
).each do |file| 
  require "restfulie/common/#{file}"
end

include ActiveSupport::CoreExtensions::Hash

