# Task: Align columns
#
# Uses `Text::justify` from the standard library.
module align_columns

fun aligner(text: String, left: Float)
do
	# Each row is a sequence of fields
	var rows = new Array[Array[String]]
	for line in text.split('\n') do
		rows.add line.split("$")
	end

	# Compute the final length of each column
	var lengths = new Array[Int]
	for fields in rows do
		var i = 0
		for field in fields do
			var fl = field.length
			if lengths.length <= i or fl > lengths[i] then
				lengths[i] = fl
			end
			i += 1
		end
	end

	# Process each line and align each field
	for fields in rows do
		var line = new Array[String]
		var i = 0
		for field in fields do
			line.add field.justify(lengths[i], left)
			i += 1
		end
		print line.join(" ")
	end
end

var text = """
Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column."""

aligner(text, 0.0)
aligner(text, 1.0)
aligner(text, 0.5)
