print "\033[?1049h\033[H";
print "Alternate screen buffer\n";

for (my $i = 5; $i > 0; --$i) {
    print "going back in $i...\n";
    sleep(1);
}

print "\033[?1049l";
