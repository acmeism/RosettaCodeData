class Camel { has Int $.humps = 1; }

my Camel $a .= new;
say $a.humps;  # Automatically generated accessor method.

my Camel $b .= new: humps => 2;
say $b.humps;
