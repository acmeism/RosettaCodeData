# 20210212 Updated Raku programming solution

sub postfix:<°>    (\ᵒ) { ᵒ × τ / 360 }

sub postfix:<㎭🡆°> (\ᶜ) { ᶜ / π × 180 }

say sin π/3 ;
say sin 60° ;

say cos π/4 ;
say cos 45° ;

say tan π/6 ;
say tan 30° ;

( asin(3.sqrt/2), acos(1/sqrt 2), atan(1/sqrt 3) )».&{ .say and .㎭🡆°.say }
