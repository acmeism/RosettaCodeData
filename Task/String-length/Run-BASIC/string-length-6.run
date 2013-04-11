# -*- coding: utf-8 -*-

class String
  # Define String#bytesize for Ruby 1.8.6.
  unless method_defined?(:bytesize)
    alias bytesize length
  end
end

s = "文字化け"
puts "Byte length: %d" % s.bytesize
puts "Character length: %d" % s.gsub(/./u, ' ').size
