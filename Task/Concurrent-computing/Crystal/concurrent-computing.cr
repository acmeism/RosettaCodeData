require "wait_group"

wg = WaitGroup.new

"Enjoy Rosetta Code".split.map do |x|
  wg.spawn do
    sleep Random.new.rand(0..500).milliseconds
    puts x
  end
end

wg.wait
