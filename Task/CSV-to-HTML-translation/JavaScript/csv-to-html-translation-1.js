var csv = "Character,Speech\n" +
	   "The multitude,The messiah! Show us the messiah!\n" +
	   "Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>\n" +
	   "The multitude,Who are you?\n" +
	   "Brians mother,I'm his mother; that's who!\n" +
	   "The multitude,Behold his mother! Behold his mother!";

var lines = csv.replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .split(/[\n\r]/)
    .map(function(line) { return line.split(',')})
    .map(function(row) {return '\t\t<tr><td>' + row[0] + '</td><td>' + row[1] + '</td></tr>';});

console.log('<table>\n\t<thead>\n'      + lines[0] +
            '\n\t</thead>\n\t<tbody>\n' + lines.slice(1).join('\n') +
            '\t</tbody>\n</table>');
