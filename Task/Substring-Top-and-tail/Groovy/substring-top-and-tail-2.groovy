def testVal = 'upraisers'
println """
original: ${testVal}
top:      ${top(testVal)}
tail:     ${tail(testVal)}
top&tail: ${tail(top(testVal))}
"""
