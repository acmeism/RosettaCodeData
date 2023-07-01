print "\e[?25l";                        # hide the cursor
print "Enter anything, press RETURN: "; # prompt shown
$input = <>;                            # but no cursor
print "\e[0H\e[0J\e[?25h";              # reset, visible again
