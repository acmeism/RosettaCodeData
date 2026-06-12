require "colorize"

"RAINBOW".chars.zip([:red, Colorize::ColorRGB.new(255, 140, 0), # orange
                     :yellow, :green, :cyan, :blue,
                     Colorize::ColorRGB.new(200, 0, 200)]       # violet
                   ) do |letter, color|
  print letter.colorize(color)
end
puts
