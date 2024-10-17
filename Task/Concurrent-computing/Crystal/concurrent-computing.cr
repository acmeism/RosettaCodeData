require "channel"
require "fiber"
require "random"

done = Channel(Nil).new

"Enjoy Rosetta Code".split.map do |x|
  spawn do
    sleep Random.new.rand(0..500).milliseconds
    puts x
    done.send nil
  end
end

3.times do
  done.receive
end
