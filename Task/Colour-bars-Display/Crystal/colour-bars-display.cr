require "colorize"

10.times do
  [:black, :red, :green, :blue, :magenta, :cyan, :yellow, :white].each do |colour|
    print ("█" * 8).colorize colour
  end
  Colorize.reset
  puts
end
