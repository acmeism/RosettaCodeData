require 'fiddle'
require 'fiddle/import'

module C
  extend Fiddle::Importer
  dlload Fiddle::Handle::DEFAULT
  extern 'char *strdup(char *)'
end

duplicate = C.strdup("This is a string!")
puts duplicate.to_s
Fiddle.free duplicate
