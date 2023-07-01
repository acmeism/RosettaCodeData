define pointsarray() => {
	local(points = array)
	loop(-from=0,-to=32) => {
		local(heading = loop_count * 11.25)
		if(loop_count % 3 == 1) => {
			#heading += 5.62
		else(loop_count % 3 == 2)
			#heading -= 5.62
		}
		#points->insert(#heading)
	}
	return #points
}
define compassShort => array(
	'N','Nbe','N-ne','Nebn','Ne','Nebe','E-ne','Ebn',
	'E','Ebs','E-se','Sebe','Se','Sebs','S-se','Sbe',
	'S','Sbw','S-sw','Swbs','Sw','Swbw','W-sw','Wbs',
	'W','Wbn','W-nw','Nwbw','Nw','Nwbn','N-nw','Nbw', 'N')
define compassLong(short::string) => {
	local(o = string)
	with i in #short->values do => { #o->append(compassLongProcessor(#i)) }
	return #o
}
define compassLongProcessor(char::string) => {
	#char == 'N' ? return #char + 'orth'
	#char == 'S' ? return #char + 'outh'
	#char == 'E' ? return #char + 'ast'
	#char == 'W' ? return #char + 'est'
	#char == 'b' ? return ' by '
	#char == '-' ? return '-'	
}
// test output points as decimals
//pointsarray

// test output the array of text values
//compassShort

// test output the long names of the text values
//with s in compassShort do => {^ compassLong(#s) + '\r' ^}

'angle  | box  | compass point
---------------------------------
'
local(counter = 0)
with p in pointsarray do => {^
	local(pformatted = #p->asString(-precision=2))
	while(#pformatted->size < 6) => { #pformatted->append(' ') }
	#counter += 1
	#counter > 32 ? #counter = 1
	#pformatted + ' |  ' + (#counter < 10 ? ' ') + #counter + '  | ' + compassLong(compassShort->get(#counter)) + '\r'
	
^}
