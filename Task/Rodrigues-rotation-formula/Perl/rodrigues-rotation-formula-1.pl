#!perl -w
use strict;
use Math::Trig; # acos
use JSON;
use constant PI => 3.14159265358979;

# Rodrigues' formula for vector rotation - see https://stackoverflow.com/questions/42358356/rodrigues-formula-for-vector-rotation

sub norm {
  my($v)=@_;
  return ($v->[0]*$v->[0] + $v->[1]*$v->[1] + $v->[2]*$v->[2]) ** 0.5;
}
sub normalize {
  my($v)=@_;
  my $length = &norm($v);
  return [$v->[0]/$length, $v->[1]/$length, $v->[2]/$length];
}
sub dotProduct {
  my($v1, $v2)=@_;
  return $v1->[0]*$v2->[0] + $v1->[1]*$v2->[1] + $v1->[2]*$v2->[2];
}
sub crossProduct {
  my($v1, $v2)=@_;
  return [$v1->[1]*$v2->[2] - $v1->[2]*$v2->[1], $v1->[2]*$v2->[0] - $v1->[0]*$v2->[2], $v1->[0]*$v2->[1] - $v1->[1]*$v2->[0]];
}
sub getAngle {
  my($v1, $v2)=@_;
  return acos(&dotProduct($v1, $v2) / (&norm($v1)*&norm($v2)))*180/PI;  # remove *180/PI to go back to radians
}
sub matrixMultiply {
  my($matrix, $v)=@_;
  return [&dotProduct($matrix->[0], $v), &dotProduct($matrix->[1], $v), &dotProduct($matrix->[2], $v)];
}
sub aRotate {
  my($p, $v, $a)=@_;    # point-to-rotate, vector-to-rotate-about, angle(degrees)
  my $ca = cos($a/180*PI);      # remove /180*PI to go back to radians
  my $sa = sin($a/180*PI);
  my $t=1-$ca;
  my($x,$y,$z)=($v->[0], $v->[1], $v->[2]);
  my $r = [
        [$ca + $x*$x*$t, $x*$y*$t - $z*$sa, $x*$z*$t + $y*$sa],
        [$x*$y*$t + $z*$sa, $ca + $y*$y*$t, $y*$z*$t - $x*$sa],
        [$z*$x*$t - $y*$sa, $z*$y*$t + $x*$sa, $ca + $z*$z*$t]
    ];
  return &matrixMultiply($r, $p);
}

my $v1 = [5,-6,4];
my $v2 = [8,5,-30];
my $a = &getAngle($v1, $v2);
my $cp = &crossProduct($v1, $v2);
my $ncp = &normalize($cp);
my $np = &aRotate($v1, $ncp, $a);

my $json=JSON->new->canonical;

print $json->encode($np) . "\n";
