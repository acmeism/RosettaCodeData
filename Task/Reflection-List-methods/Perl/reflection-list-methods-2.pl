use Class::MOP;
my $meta = Class::MOP::Class->initialize( ref $a );
say join "\n", $meta->get_all_method_names()
