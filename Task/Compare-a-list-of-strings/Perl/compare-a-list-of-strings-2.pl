join("\0", @strings) =~ /^ ( [^\0]*+ ) (?: \0 \1 )* $/x  # All equal
