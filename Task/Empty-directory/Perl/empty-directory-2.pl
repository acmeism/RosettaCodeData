use IO::Dir;
sub dir_is_empty { !grep !/^\.{1,2}\z/, IO::Dir->new(@_)->read }
