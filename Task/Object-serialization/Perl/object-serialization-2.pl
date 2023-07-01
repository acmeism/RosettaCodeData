use MooseX::Declare;

class Greeting {
    use MooseX::Storage;
    with Storage('format' => 'JSON', io => 'File');
    has string => (is => 'ro', default => "Hello world!\n");
}
class Son::Of::Greeting extends Greeting {
    has string => (is => 'ro', default => "Hello from Junior!\n");
}

my $g1 = Greeting->new;
my $s1 = Son::Of::Greeting->new;

print $g1->string;
print $s1->string;

$g1->store('object1.json');
my $g2 = Greeting->load('object1.json');

$s1->store('object2.json');
my $s2 = Son::Of::Greeting->load('object2.json');

print $g2->string;
print $s2->string;
