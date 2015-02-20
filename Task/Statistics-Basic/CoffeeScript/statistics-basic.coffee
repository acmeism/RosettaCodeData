generate_statistics = (n) ->
  hist = {}

  update_hist = (r) ->
    hist[Math.floor 10*r] ||= 0
    hist[Math.floor 10*r] += 1

  sum = 0
  sum_squares = 0.0

  for i in [1..n]
    r = Math.random()
    sum += r
    sum_squares += r*r
    update_hist r
  mean = sum / n
  stddev = Math.sqrt((sum_squares / n) - mean*mean)

  [n, mean, stddev, hist]

display_statistics = (n, mean, stddev, hist) ->
  console.log "-- Stats for sample size #{n}"
  console.log "mean: #{mean}"
  console.log "sdev: #{stddev}"
  for x, cnt of hist
    bars = repeat "=", Math.floor(cnt*300/n)
    console.log "#{x/10}: #{bars} #{cnt}"

repeat = (c, n) ->
  s = ''
  s += c for i in [1..n]
  s

for n in [100, 1000, 10000, 1000000]
  [n, mean, stddev, hist] = generate_statistics n
  display_statistics n, mean, stddev, hist
