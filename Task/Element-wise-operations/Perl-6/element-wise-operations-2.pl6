sub infix:<M+> (\l,\r) { l <<+>> r }

msay @a M+ @a;
msay @a M+ [1,2,3];
msay @a M+ 2;
