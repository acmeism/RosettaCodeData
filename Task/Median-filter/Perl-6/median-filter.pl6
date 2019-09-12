# Reference: https://github.com/azawawi/perl6-magickwand

# WIP by module author

#!/usr/bin/env perl6

use v6;

use MagickWand;

# A new magic wand
my $original = MagickWand.new;

# Read an image
$original.read("image/example.jpg");

# apply median filter
say "Median Filter...";
my $o = $original.clone;
$o.median-filter;
$o.label("Median Filter");
# And then write a new image
$o.write("output.png");

# And cleanup on exit
LEAVE {
  $original.cleanup   if $original.defined;
  $o.cleanup if $o.defined;
}
