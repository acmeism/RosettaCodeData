require 'dl/import'

FakeImgLib = DL.dlopen("/path/to/fakeimg.so")

module FakeImage
  def self.openimage filename
    FakeImgLib["openimage", "IS"].call(filename)[0]
  end
end

handle = FakeImage.openimage("path/to/image")
