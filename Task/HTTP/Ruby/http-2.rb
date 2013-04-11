require 'fileutils'
require 'open-uri'

open("http://rosettacode.org/") {|f| FileUtils.copy_stream(f, $stdout)}
