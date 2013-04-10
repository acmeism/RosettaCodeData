var csv = "Character,Speech\n" +
	   "The multitude,The messiah! Show us the messiah!\n" +
	   "Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>\n" +
	   "The multitude,Who are you?\n" +
	   "Brians mother,I'm his mother; that's who!\n" +
	   "The multitude,Behold his mother! Behold his mother!";

csv = csv.replace(/&/g, '&amp;')
         .replace(/</g, '&lt;')
         .replace(/>/g, '&gt;')
         .replace(/"/g, '&quot;');

var lines = csv.split(/[\n\r]+/g),
    header = lines.shift().split(","),
    line,
    rows = "",
    thead = '<tr>'+
		'<th>'+header[0]+'</th>'+
		'<th>'+header[1]+'</th>'+
	    '</tr>\n';

for (var i=0, len=lines.length; i<len; i++) {
    line = lines[i].split(",");
    rows += '<tr>'+
		'<td>'+line[0]+'</td>'+
		'<td>'+line[1]+'</td>'+
	    '</tr>\n';
}

console.log('<table><thead>\n' + thead + '</thead><tbody>\n' + rows + '</tbody></table>' );
