#!/usr/bin/env raku

sub MAIN (Int :l(:len(:$length))) {
   my Str $String = "Here am I";
   $*OUT.print: $String if $String.codes ≤ $length
}
