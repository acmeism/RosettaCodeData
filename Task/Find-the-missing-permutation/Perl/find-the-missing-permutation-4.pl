local $_ = join '', <>;
my %h = map { $_, '' } reverse =~ /\w+/g;
delete @h{ /\w+/g };
print %h, "\n";
