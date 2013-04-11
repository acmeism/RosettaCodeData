print_power_set = (arr) ->
  console.log "POWER SET of #{arr}"
  for subset in power_set(arr)
    console.log subset

power_set = (arr) ->
  result = []
  binary = (false for elem in arr)
  n = arr.length
  while binary.length <= n
    result.push bin_to_arr binary, arr
    i = 0
    while true
      if binary[i]
        binary[i] = false
        i += 1
      else
        binary[i] = true
        break
    binary[i] = true
  result

bin_to_arr = (binary, arr) ->
  (arr[i] for i of binary when binary[arr.length - i  - 1])

print_power_set []
print_power_set [4, 2, 1]
print_power_set ['dog', 'c', 'b', 'a']
