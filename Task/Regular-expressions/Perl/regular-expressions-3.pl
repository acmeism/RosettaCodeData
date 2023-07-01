$string = "I am a string";
$string2 = $string =~ s/ a / another /r; # $string2 == "I am another string", $string is unaltered
print $string2;
