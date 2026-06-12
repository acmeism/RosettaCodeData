def simulation (c)
  max_trials = 1_000_000
  min_trials =    10_000
  n = (47 * (c - 1.5)**1.5).to_i  # OEIS/A050256: 16 86 185 307
  trials = { max_trials, { min_trials, (1000 * Math.sqrt(n)).to_i }.max }.min

  loop do
    yes = (1..trials).count {
      (1..n).map { rand(365) }.tally.any? {|_, v| v >= c }
    }
    p = yes/trials
    return { n, p }  if p > 0.5
    trials = { max_trials, { min_trials, (1000 / (0.5 - p)**1.75).to_i }.max }.min
    n += 1
  end
end

(2..5).each do |c|
  printf "%d people in a group of %d share a common birthday (%.4f)\n",
         c, *simulation(c)
end
