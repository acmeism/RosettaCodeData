# 20230327 Raku programming solution

use Math::Matrix;

class AdditionChains { has ( $.idx, $.pos, @.chains, @.lvl, %.pat ) is rw;

   method add_chain {
      # method 1: add chains depth then breadth first until done
      return gather given self {
         take my $newchain = .chains[.idx].clone.append:
            .chains[.idx][*-1] + .chains[.idx][.pos];
	     .chains.append: $newchain;
         .pos == +.chains[.idx]-1 ?? ( .idx += 1 && .pos = 0 ) !! .pos += 1;
      }
   }

   method find_chain(\nexp where nexp > 0) {
   # method 1 interface: search for chain ending with n, adding more as needed
      return ([1],) if nexp == 1;
      my @chn = self.chains.grep: *.[*-1] == nexp // [];
      unless @chn.Bool {
         repeat { @chn = self.add_chain } until @chn[*-1][*-1] == nexp
      }
      return @chn
   }

   method knuth_path(\ngoal) {
      # method 2: knuth method, uses memoization to search for a shorter chain
      return [] if ngoal < 1;
      until self.pat{ngoal}:exists {
         self.lvl[0] = [ gather for self.lvl[0].Array -> \i {
            for self.knuth_path(i).Array -> \j {
               unless self.pat{i + j}:exists {
                  self.pat{i + j} = i and take i + j
               }
            }
         } ]
      }
      return self.knuth_path(self.pat{ngoal}).append: ngoal
   }

   multi method cpow(\xbase, \chain) {
#  raise xbase by an addition exponentiation chain for what becomes x**chain[-1]
      my ($pows, %products) = 0, 1 => xbase;

      %products{0} = xbase ~~ Math::Matrix
         ?? Math::Matrix.new([ [ 1 xx xbase.size[1] ] xx xbase.size[0] ]) !! 1;

      for chain.Array -> \i {
         %products{i} = %products{$pows} * %products{i - $pows};
         $pows = i
      }
      return %products{ chain[*-1] }
   }
}

my $chn =  AdditionChains.new( idx    =>      0, pos =>      0,
                               chains => ([1],), lvl => ([1],), pat => {1=>0} );

say 'First one hundred addition chain lengths:';
.Str.say for ( (1..100).map: { +$chn.find_chain($_)[0] - 1 } ).rotor: 10;

my %chns = (31415, 27182).map: { $_ => $chn.knuth_path: $_ };

say "\nKnuth chains for addition chains of 31415 and 27182:";
say "Exponent: $_\n  Addition Chain: %chns{$_}[0..*-2]" for %chns.keys;
say '1.00002206445416^31415 = ', $chn.cpow(1.00002206445416, %chns{31415});
say '1.00002550055251^27182 = ', $chn.cpow(1.00002550055251, %chns{27182});
say '(1.000025 + 0.000058i)^27182 = ', $chn.cpow: 1.000025+0.000058i, %chns{27182};
say '(1.000022 + 0.000050i)^31415 = ', $chn.cpow: 1.000022+0.000050i, %chns{31415};

my \sq05 = 0.5.sqrt;
my \mat  = Math::Matrix.new( [[sq05,    0, sq05,     0, 0, 0],
                             [    0, sq05,    0,  sq05, 0, 0],
                             [    0, sq05,    0, -sq05, 0, 0],
                             [-sq05,    0, sq05,     0, 0, 0],
                             [    0,    0,    0,     0, 0, 1],
                             [    0,    0,    0,     0, 1, 0]] );

say 'matrix A ^ 27182 =';
say my $res27182 = $chn.cpow(mat, %chns{27182});
say 'matrix A ^ 31415 =';
say $chn.cpow(mat, %chns{31415});
say '(matrix A ** 27182) ** 31415 =';
say $chn.cpow($res27182, %chns{31415});
