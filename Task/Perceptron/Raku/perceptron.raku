# 20201116 Raku programming solution

use MagickWand;

our ( \c, \runs ) = 0.00001, 2000 ;

class Trainer { has ( @.inputs, $.answer ) is rw }

sub linear(\x) { return x*0.7 + 40 }

class Perceptron {

   has ( @.weights, Trainer @.training ) is rw ;

   submethod BUILD(:n($n), :w($w), :h($h)) {
      @!weights  = [ rand*2-1 xx ^$n ];
      @!training = (^runs).map: {
          my (\x,\y) = rand*$w , rand*$h ;
          my \a      = y < linear(x) ?? 1 !! -1;
          Trainer.new: inputs => (x,y,1), answer => a
      }
   }

   method feedForward(@inputs) {
      die "weights and input length mismatch" if +@inputs != +self.weights;
      return ( sum( @inputs »*« self.weights ) > 0 ) ?? 1 !! -1
   }

   method train(@inputs, \desired) {
      self.weights »+«= @inputs »*» (c*(desired - self.feedForward(@inputs)))
   }

   method draw(\img) {
      for ^runs { self.train(self.training[$_].inputs, self.training[$_].answer) }
      my $y = linear(my $x = img.width) ;
      img».&{ .stroke-width(3) or .stroke('black') or .fill('none') } # C returns
      img.draw-line(0.0, linear(0), $x, $y);
      img.stroke-width( 1 );
      for ^runs {
         my $guess = self.feedForward(self.training[$_].inputs);
         ($x, $y) = self.training[$_].inputs[0,1] »-» 4;
         $guess > 0 ?? img.stroke( 'blue' ) !! img.stroke( 'red' );
         img.circle( $x, $y, $x+8, $y );
      }
   }
}

my ($w, $h) = 640, 360;
my $perc = Perceptron.new: n => 3, w => $w, h => $h;
my $o = MagickWand.new or die;
$o.create( $w, $h, "white" );
$perc.draw($o);
$o.write('./perceptron.png') or die
