(
var text, words, sdrow, semordnilap, selection;
File.use("unixdict.txt".resolveRelative, "r", { |f| x = text = f.readAllString });
words = text.split(Char.nl).collect { |each| each.asSymbol };
sdrow = text.reverse.split(Char.nl).collect { |each| each.asSymbol };
semordnilap = sect(words, sdrow); // converted to symbols so intersection is possible
semordnilap = semordnilap.collect { |each| each.asString };
"There are % in unixdict.txt\n".postf(semordnilap.size);
"For example those, with more than 3 characters:".postln;
selection = semordnilap.select { |each| each.size >= 4 }.scramble.keep(4);
selection.do { |each| "% %\n".postf(each, each.reverse); };
)
