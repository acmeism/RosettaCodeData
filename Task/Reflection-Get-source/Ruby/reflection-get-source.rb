require 'mathn'
Math.method(:sqrt).source_location
# ["/usr/local/lib/ruby2.3/2.3.0/mathn.rb", 119]

Class.method(:nesting).source_location
# nil, since Class#nesting is native
