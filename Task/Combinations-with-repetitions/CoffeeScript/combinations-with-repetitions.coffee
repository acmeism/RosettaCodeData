combos = (arr, k) ->
  return [ [] ] if k == 0
  return [] if arr.length == 0

  combos_with_head = ([arr[0]].concat combo for combo in combos arr, k-1)
  combos_sans_head = combos arr[1...], k
  combos_with_head.concat combos_sans_head

arr = ['iced', 'jam', 'plain']
console.log "valid pairs from #{arr.join ','}:"
console.log combos arr, 2
console.log "#{combos([1..10], 3).length} ways to order 3 donuts given 10 types"
