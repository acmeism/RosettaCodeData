# Redefine as necessary for target platform.
println = (z) -> console.log z

testData = [
	[
		"what,is,the;meaning,of:life."
		"what,si,the;gninaem,of:efil."
	]
	[
		"we,are;not,in,kansas;any,more."
		"we,era;not,ni,kansas;yna,more."
	]
]

results = for [testString, expectedResult] in testData
	# This test machinery uses string buffers for input and output. If your JS
	# platform sports single-character I/O, by all means, adapt to taste.
	getCursor = 0
	putBuffer = ""
	get = ->
		testString.charAt getCursor++
	put = (c) ->
		putBuffer += c
	oddWord(get,put)
	[testString, expectedResult, putBuffer, putBuffer is expectedResult]

println result for result in results
