use Math::Pari qw/znorder Mod/;
say znorder(Mod(54, 100001));
say znorder(Mod(11, 1 + Math::Pari::PARI(10)**100));
