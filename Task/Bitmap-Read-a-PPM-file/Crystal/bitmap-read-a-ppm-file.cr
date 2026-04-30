require "./pixmap"

class Pixmap
  def self.load_ppm (io)
    blanks = StaticArray[9, 10, 11, 12, 13, 32]
    magic = Bytes.new(3)
    io.read magic
    raise "Invalid format" unless magic[0] == 'P'.ord &&
                                  magic[1] == '6'.ord &&
                                  magic[2].in? blanks
    data = io.getb_to_end
    pos = 0
    get_number = -> : Int32 {
      start = pos
      loop do  # skip blanks and comments
        case data[start]
        when .in? blanks then start += 1
        when '#'.ord
          while data[start] != 10
            start += 1
          end
        else break
        end
      end
      stop = start
      until data[stop].in? blanks
        stop += 1
      end
      pos = stop
      String.new(data[start..stop]).to_i
    }
    begin
      width  = get_number.call
      height = get_number.call
      maxval = get_number.call
    rescue ex
      raise "Bad P6 file"
    end
    raise "Unsupported color depth" unless maxval = 255
    pos += 1
    raise "Invalid data" unless (data.size - pos) % 3 == 0
    len = (data.size - pos) // 3
    raise "Bad bounds" unless len == width * height
    pixels = Array(Color).new(len) { |i|
      Color.new(data[i*3 + pos], data[i*3 + pos + 1], data[i*3 + pos + 2])
    }
    Pixmap.new width, height, pixels
  end

  register_loader ".ppm", load_ppm
end
