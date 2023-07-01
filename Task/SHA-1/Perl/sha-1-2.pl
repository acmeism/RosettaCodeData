use Digest::SHA;

my $sha1 = Digest::SHA->new(1);
$sha1->add('Rosetta Code');
print $sha1->hexdigest, "\n";
