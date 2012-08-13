Encoding.default_internal = "UTF-8"
Encoding.default_external = "UTF-8"

$:.unshift( './lib')

require 'karaoke/basic'
require 'karaoke/data_model'

run Karaoke::App
