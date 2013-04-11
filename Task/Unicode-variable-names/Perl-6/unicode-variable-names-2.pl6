my @ᐁ = (0, 45, 60, 90);

sub π { pi };

sub postfix:<°>($degrees) { $degrees * π / 180 };

for @ᐁ -> $ಠ_ಠ { say sin $ಠ_ಠ° };
