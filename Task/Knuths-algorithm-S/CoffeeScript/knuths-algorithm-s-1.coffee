s_of_n_creator = (n) ->
  arr = []
  cnt = 0
  (elem) ->
    cnt += 1
    if cnt <= n
      arr.push elem
    else
      pos = Math.floor(Math.random() * cnt)
      if pos < n
        arr[pos] = elem
    arr.sort()

sample_size = 3
range = [0..9]
num_trials = 100000

counts = {}

for digit in range
  counts[digit] = 0

for i in [1..num_trials]
  s_of_n = s_of_n_creator(sample_size)
  for digit in range
    sample = s_of_n(digit)
  for digit in sample
    counts[digit] += 1

for digit in range
  console.log digit, counts[digit]
