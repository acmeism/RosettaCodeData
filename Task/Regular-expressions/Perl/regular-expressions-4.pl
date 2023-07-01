$string = "I am a string";
if ($string =~ s/\bam\b/was/) { # \b is a word border
   print "I was able to find and replace 'am' with 'was'\n";
}
