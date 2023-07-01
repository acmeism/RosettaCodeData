F = (n) ->
  if n is 0 then 1 else n - M F n - 1

M = (n) ->
  if n is 0 then 0 else n - F M n - 1

console.log [0...20].map F
console.log [0...20].map M
