require 'tempfile'
require 'fileutils'
require 'English'

def remove_lines(filename, start, num)
  tmp = Tempfile.new(filename)
  File.foreach(filename) do |line|
    if $NR >= start and num > 0
      num -= 1
    else
      tmp.write line
    end
  end
  tmp.close
  STDERR.puts "Warning: End of file encountered before all lines removed" if num > 0
  FileUtils.copy(tmp.path, filename)
  tmp.unlink
end
