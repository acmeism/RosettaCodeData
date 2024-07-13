use strict;
use warnings;

local $/ = "";  # Set the input record separator to an empty string to read paragraph mode
local $\ = "\n----------------\n";  # Set the output record separator

# Open the file Traceback.txt for reading
open my $fh, '<', 'Traceback.txt' or die "Cannot open Traceback.txt: $!";

# Read one paragraph at a time
while (<$fh>) {
    if (/Traceback \(most recent call last\):/ && /SystemError/) {
        print substr($_, index($_, "Traceback (most recent call last):"));
    }
}
