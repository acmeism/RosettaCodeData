package Digest::SHA256::PP;

use strict;
use warnings;

use constant WORD => 2**32;
use constant MASK => WORD - 1;

my @h;
my @k;

for my $p ( 2 .. 311 ) {
   # Horrible primality test, but sufficient for this task.
   next if ("1" x $p) =~ /^(11+?)\1+$/;
   # The choice to generate h and k instead of hard coding
   # them is inspired by the Raku implementation.
   my $c = $p ** ( 1/3 );
   push @k, int( ($c - int $c) * WORD );
   next if @h == 8;
   my $s = $p ** ( 1/2 );
   push @h, int( ($s - int $s) * WORD );
}

sub new {
   my %self = ( state => [@h], str => "", len => 0 );
   bless \%self, shift;
}

my $rightrotate = sub {
   my $lo = $_[0] >> $_[1];
   my $hi = $_[0] << (32 - $_[1]);
   ($hi | $lo);
};

# This is adapted from the wikipedia entry on SHA2.
my $compress = sub {
   my ($state, $bytes) = @_;
   my @w = unpack 'N*', $bytes;
   @w == 16 or die 'internal error';
   my ($a, $b, $c, $d, $e, $f, $g, $h) = @$state;
   until( @w == 64 ) {
      my $s0 = $w[-15] >> 3;
      my $s1 = $w[-2] >> 10;
      $s0 ^= $rightrotate->($w[-15], $_) for 7, 18;
      $s1 ^= $rightrotate->($w[-2], $_) for 17, 19;
      push @w, ($w[-16] + $s0 + $w[-7] + $s1) & MASK;
   }
   my $i = 0;
   for my $w (@w) {
      my $ch = ($e & $f) ^ ((~$e) & $g);
      my $maj = ($a & $b) ^ ($a & $c) ^ ($b & $c);
      my ($S0, $S1) = (0, 0);
      $S1 ^= $rightrotate->( $e, $_ ) for 6, 11, 25;
      $S0 ^= $rightrotate->( $a, $_ ) for 2, 13, 22;
      my $temp1 = $h + $S1 + $ch + $k[$i++] + $w;
      my $temp2 = $S0 + $maj;
      ($h, $g, $f, $e, $d, $c, $b, $a) =
         ($g, $f, $e, ($d+$temp1)&MASK, $c, $b, $a, ($temp1+$temp2)&MASK);
   }
   my $j = 0;
   $state->[$j++] += $_ for $a, $b, $c, $d, $e, $f, $g, $h;
};

use constant can_Q => eval { length pack 'Q>', 0 };

sub add {
   my ($self, $bytes) = @_;
   $self->{len} += 8 * length $bytes;
   if( !can_Q and $self->{len} >= WORD ) {
      my $hi = int( $self->{len} / WORD );
      $self->{big} += $hi;
      $self->{len} -= $hi * WORD;
   }
   my $len = length $self->{str};
   if( ($len + length $bytes) < 64 ) {
      $self->{str} .= $bytes;
      return $self;
   }
   my $off = 64 - $len;
   $compress->( $self->{state}, $self->{str} . substr( $bytes, 0, $off ) );
   $len = length $_[0];
   while( $off+64 <= $len ) {
      $compress->( $self->{state}, substr( $bytes, $off, 64 ) );
      $off += 64;
   }
   $self->{str} = substr( $bytes, $off );
   $self;
}

sub addfile {
   my ($self, $fh) = @_;
   my $s = "";
   while( read( $fh, $s, 2**13 ) )  {
      $self->add( $s );
   }
   $self;
}


sub digest {
   my $self = shift;
   my $final = $self->{str};
   $final .= chr 0x80;
   while( ( 8+length $final ) % 64 ) {
      $final .= chr 0;
   }
   if( can_Q ) {
      $final .= pack 'Q>', $self->{len};
   } else {
      $self->{big} ||= 0;
      $final .= pack 'NN', $self->{big}, $self->{len};
   }
   $compress->( $self->{state}, substr $final, 0, 64, "" ) while length $final;
   if( wantarray ) {
      map pack('N', $_), @{ $self->{state} };
   } else {
      pack 'N*', @{ $self->{state} };
   }
}

sub hexdigest {
   if( wantarray ) {
      map unpack( 'H*', $_), &digest;
   } else {
      unpack 'H*', &digest;
   }
}

unless( caller ) {
   my @testwith = (@ARGV ? @ARGV : 'Rosetta code');
   for my $str (@testwith) {
      my $digester = __PACKAGE__->new;
      $digester->add($str);
      print "'$str':\n";
      print join(" ", $digester->hexdigest), "\n";
   }
}

1;
