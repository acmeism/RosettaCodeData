def sleeping_beauty_experiment(n)
  coin = [:heads, :tails]
  gotheadsonwaking = 0
  wakenings = 0
  n.times do
    wakenings += 1
    coin.sample == :heads ? gotheadsonwaking += 1 : wakenings += 1
  end
  puts "Wakenings over #{n} experiments: #{wakenings}"
  gotheadsonwaking / wakenings.to_f
end

puts "Results of experiment: Sleeping Beauty should estimate
a credence of: #{sleeping_beauty_experiment(1_000_000)}"
