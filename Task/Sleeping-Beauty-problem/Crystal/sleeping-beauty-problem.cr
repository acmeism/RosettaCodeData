iterations = 10_000_000

wakings = heads = 0
r = Random.new

iterations.times do
  wakings += 1
  if r.next_bool  # heads?
    heads += 1
  else
    wakings += 1
  end
end

puts heads/wakings
