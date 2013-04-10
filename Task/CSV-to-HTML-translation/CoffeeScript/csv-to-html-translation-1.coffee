String::__defineGetter__ 'escaped', () ->
	this.replace(/&/g, '&amp;')
	    .replace(/</g, '&lt;')
	    .replace(/>/g, '&gt;')
	    .replace(/"/g, '&quot;') // rosettacode doesn't like "

text = '''
Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!
'''

lines = (line.split ',' for line in text.split /[\n\r]+/g)

header = lines.shift()

console.log """
<table cellspacing="0">
	<thead>
		<th scope="col">#{header[0]}</th>
		<th scope="col">#{header[1]}</th>
	</thead>
	<tbody>
"""

for line in lines
	[character, speech] = line
	console.log """
		<th scope="row">#{character}</th>
		<td>#{speech.escaped}</td>
	"""

console.log """
	</tbody>
</table>
	"""
