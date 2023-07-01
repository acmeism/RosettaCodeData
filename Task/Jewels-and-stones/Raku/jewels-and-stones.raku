sub count-jewels ( Str $j, Str $s --> Int ) {
    my %counts_of_all = $s.comb.Bag;
    my @jewel_list    = $j.comb.unique;

    return %counts_of_all ∩ @jewel_list.Bag ?? %counts_of_all{ @jewel_list }.sum !! 0;
}

say count-jewels 'aA' , 'aAAbbbb';
say count-jewels 'z'  , 'ZZ';
