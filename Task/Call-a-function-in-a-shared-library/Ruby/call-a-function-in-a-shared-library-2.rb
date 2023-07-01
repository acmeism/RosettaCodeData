# This script shows the width x height of some images.
# Example:
#   $ ruby imsize.rb dwarf-vs-elf.png swedish-chef.jpg
#   dwarf-vs-elf.png: 242x176
#   swedish-chef.jpg: 256x256

begin
  require 'rmagick'
  lib = :rmagick
rescue LoadError
  # Missing rmagick.  Try ffi.
  begin
    require 'ffi'
    module F
      extend FFI::Library
      ffi_lib 'MagickWand-6.Q16'
      attach_function :DestroyMagickWand, [:pointer], :pointer
      attach_function :MagickGetImageHeight, [:pointer], :size_t
      attach_function :MagickGetImageWidth, [:pointer], :size_t
      attach_function :MagickPingImage, [:pointer, :string], :bool
      attach_function :MagickWandGenesis, [], :void
      attach_function :NewMagickWand, [], :pointer
    end
    lib = :ffi
  rescue LoadError
    # Missing ffi, MagickWand lib, or function in lib.
  end
end

case lib
when :rmagick
  # Returns [width, height] of an image file.
  def size(path)
    img = Magick::Image.ping(path).first
    [img.columns, img.rows]
  end
when :ffi
  F.MagickWandGenesis()
  def size(path)
    wand = F.NewMagickWand()
    F.MagickPingImage(wand, path) or fail 'problem reading image'
    [F.MagickGetImageWidth(wand), F.MagickGetImageHeight(wand)]
  ensure
    F.DestroyMagickWand(wand) if wand
  end
else
  PngSignature = "\x89PNG\r\n\x1A\n".force_encoding('binary')
  def size(path)
    File.open(path, 'rb') do |file|
      # Only works with PNG: https://www.w3.org/TR/PNG/
      # Reads [width, height] from IDHR chunk.
      # Checks height != nil, but doesn't check CRC of chunk.
      sig, width, height = file.read(24).unpack('a8@16NN')
      sig == PngSignature and height or fail 'not a PNG image'
      [width, height]
    end
  end
end

# Show the size of each image in ARGV.
status = true
ARGV.empty? and (warn "usage: $0 file..."; exit false)
ARGV.each do |path|
  begin
    r, c = size(path)
    puts "#{path}: #{r}x#{c}"
  rescue
    status = false
    puts "#{path}: #$!"
  end
end
exit status
