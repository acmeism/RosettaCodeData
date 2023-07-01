constant $sides = 5;
constant order  = 5;
constant $dim   = 250;
constant scaling-factor = ( 3 - 5**.5 ) / 2;
my @orders = ((1 - scaling-factor) * $dim) «*» scaling-factor «**» (^order);

my $fh = open('sierpinski_pentagon.svg', :w);

$fh.say: qq|<svg height="{$dim*2}" width="{$dim*2}" style="fill:blue" version="1.1" xmlns="http://www.w3.org/2000/svg">|;

my @vertices = map { cis( $_ * τ / $sides ) }, ^$sides;

for 0 ..^ $sides ** order -> $i {
   my $vector = [+] @vertices[$i.base($sides).fmt("%{order}d").comb] «*» @orders;
   $fh.say: pgon ((@orders[*-1] * (1 - scaling-factor)) «*» @vertices «+» $vector)».reals».fmt("%0.3f");
};

sub pgon (@q) { qq|<polygon points="{@q}" transform="translate({$dim},{$dim}) rotate(-18)"/>| }

$fh.say: '</svg>';
$fh.close;
