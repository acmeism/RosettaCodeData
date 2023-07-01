$string = "I am a string";
if ($string =~ /string$/) {
   print "Ends with 'string'\n";
}

if ($string !~ /^You/) {
   print "Does not start with 'You'\n";
}
