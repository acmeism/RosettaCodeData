require 'fiddle/import'

module FakeImgLib
  extend Fiddle::Importer
  begin
    dlload './fakeimglib.so'
    extern 'int openimage(const char *)'
  rescue Fiddle::DLError
    # Either fakeimglib or openimage() is missing.
    @@handle = -1
    def openimage(path)
      $stderr.puts "internal openimage opens #{path}\n"
      @@handle += 1
    end
    module_function :openimage
  end
end

handle = FakeImgLib.openimage("path/to/image")
puts "opened with handle #{handle}"
