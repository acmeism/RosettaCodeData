my $str = "Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!";

# comment the next line out, if you want to read from standard input instead of the hard-coded $str above
# my $str = $*IN.slurp;

my &escape = *.trans(« & < > » => « &amp; &lt; &gt; »); # a function with one argument that escapes the entities
my &tag    = {"<$^tag>"~$^what~"</$^tag>"};

printf
'<!DOCTYPE html>
<html>
<head><title>Some Text</title></head>
<body><table>
%s
</table></body></html>
', [~]                                # concatenation reduction ('a', 'b', 'c') → 'abc'
(escape($str).split(/\n/)             # escape the string and split at newline
  ==> map -> $line {tag 'tr',         # feed that into a map, that map function will tag as 'tr, and has an argument called $line
    ([~] $line.split(/','/)\          # split $line at ',',
                                      # that / at the end is just an unspace, you can omit it, but then you have to delete
                                      # all whitespace  and comments between split(…) and .map
      .map({tag 'td', $^cell}))})\    # map those cells as td
		       .join("\n");   # append a newline for nicer output
