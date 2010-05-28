module Restfulie::Client::HTTP#:nodoc:
end

%w(
  error
  adapter
  cache
  marshal
  atom_ext
  json_ext
  xml_ext
  core_ext
).each do |file|
  require "restfulie/client/http/#{file}"
end

