module Screen
  IMPORT_COMMAND = '/usr/bin/import'

  # Returns an array with RGB values for the pixel at the given coords
  def self.pixel(x, y)
    if m = `#{IMPORT_COMMAND} -silent -window root -crop 1x1+#{x.to_i}+#{y.to_i} -depth 8 txt:-`.match(/\((\d+),(\d+),(\d+)\)/)
      m[1..3].map(&:to_i)
    else
      false
    end
  end
end
