require 'fileutils'
moves = { "input.txt" => "output.txt", "/input.txt" => "/output.txt", "docs" => "mydocs","/docs" => "/mydocs"}
moves.each{ |src, dest| FileUtils.move( src, dest, :verbose => true ) }
