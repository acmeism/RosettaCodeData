sub isleap { not $_[0] % ($_[0] % 100 ? 4 : 400) }
