define rand4dig => integer_random(9999, 1)

local(
	output = '<table border=2 cellpadding=5  cellspace=0>\n<tr>'
)

with el in ('&#160;,X,Y,Z') -> split(',') do {
	#output -> append('<th>' + #el + '</th>')
}
#output -> append('</tr>\n')

loop(5) => {
	#output -> append('<tr>\n<td style="font-weight: bold;">' + loop_count + '</td>')
	loop(3) => {
		#output -> append('<td>' + rand4dig + '</td>')
	}
	#output -> append('</tr>\n')
}
#output -> append('</table>\n')

#output
