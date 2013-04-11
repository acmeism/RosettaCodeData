ordered_keys = ["aleph", "beth", "gimel", "daleth", "he", "waw", "zayin", "heth"]
probabilities = {
  "aleph"  => 1/5.0,
  "beth"   => 1/6.0,
  "gimel"  => 1/7.0,
  "daleth" => 1/8.0,
  "he"     => 1/9.0,
  "waw"    => 1/10.0,
  "zayin"  => 1/11.0,
}
probabilities["heth"] = probabilities.each_value.inject(1) {|heth, value| heth -= value}

sums = {}
ordered_keys.each.inject(0) do |sum, key|
  sum += probabilities[key]
  sums[key] = sum
end

actual = Hash.new(0)

samples = 1_000_000
samples.times do
  r = rand
  for k in ordered_keys
    if r < sums[k]
      actual[k] += 1
      break
    end
  end
end

printf "%-6s  %-19s  %s\n", "key", "expected", "actual"
for k in ordered_keys
  printf "%-6s  %.17f  %.6f\n", k, probabilities[k], Float(actual[k])/samples
end
