let strings = [
	"",
	#""If I were two-faced, would I be wearing this one?" --- Abraham Lincoln "#,
	"..1111111111111111111111111111111111111111111111111111111111111117777888",
	"I never give 'em hell, I just tell the truth, and they think it's hell. ",
	"                                                   ---  Harry S Truman  ",
	"The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
	"headmistressship",
	"aardvark",
	"😍😀🙌💃😍😍😍🙌"
]

let collapsedStrings = strings.map { $0.replacingOccurrences( of: #"(.)\1*"#, with: "$1", options: .regularExpression)}

for (original, collapsed) in zip(strings, collapsedStrings) {
	print (String(format: "%03d «%@»\n%03d «%@»\n", original.count, original, collapsed.count, collapsed))
}
