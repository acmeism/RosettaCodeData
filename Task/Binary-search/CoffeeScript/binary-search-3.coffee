do (n = 12) ->
  odds = (it for it in [1..n] by 2)
  result = (it for it in \
    (binarySearch odds, it for it in [0..n]) \
    when not isNaN it)
  console.assert "#{result}" is "#{[0...odds.length]}"
  console.log "#{odds} are odd natural numbers"
  console.log "#{it} is ordinal of #{odds[it]}" for it in result
