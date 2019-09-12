use utf8;
binmode STDOUT, ":utf8";

# to reverse characters (code points):
print reverse('visor'), "\n";

# to reverse graphemes:
print join("", reverse "José" =~ /\X/g), "\n";

$string = 'ℵΑΩ 駱駝道 🤔 🇸🇧 🇺🇸 🇬🇧‍ 👨‍👩‍👧‍👦🆗🗺';
print join("", reverse $string =~ /\X/g), "\n";
