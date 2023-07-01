use Sys::Mmap;
Sys::Mmap->new(my $str, 0, 'foo.txt')
  or die "Cannot Sys::Mmap->new: $!";
print $str;
