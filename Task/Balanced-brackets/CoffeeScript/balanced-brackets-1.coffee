isBalanced = (brackets) ->
  openCount = 0
  for bracket in brackets
    openCount += if bracket is '[' then 1 else -1
    return false if openCount < 0
  openCount is 0

bracketsCombinations = (n) ->
  for i in [0...Math.pow 2, n]
    str = i.toString 2
    str = '0' + str while str.length < n
    str.replace(/0/g, '[').replace(/1/g, ']')

for brackets in bracketsCombinations 4
  console.log brackets, isBalanced brackets
