# 20211001 Raku programming solution

enum MultitonType < Gold Silver Bronze >;

class Multiton {

   my %instances = MultitonType.keys Z=> $ ⚛= 1 xx * ;

   has $.type is rw;

   method TWEAK { $.type = 'Nothing' unless cas(%instances{$.type}, 1, 0) }
}

race for ^10 -> $i {
   Thread.start(
      sub {
#         sleep roll(^2);
         my $obj = Multiton.new: type => MultitonType.roll;
         say "Thread ", $i, " has got ", $obj.type;
      }
   );
}
