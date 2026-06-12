#!/usr/bin/perl
use strict ;
use warnings ;

sub mostFreqHashing {
   my $inputstring = shift ;
   my $howmany = shift ;
   my $outputstring ;
   my %letterfrequencies = findFrequencies ( $inputstring ) ;
   my @orderedChars = sort { $letterfrequencies{$b} <=> $letterfrequencies{$a} ||
      index( $inputstring , $a ) <=> index ( $inputstring , $b ) } keys %letterfrequencies ;
   for my $i ( 0..$howmany - 1 ) {
      $outputstring .= ( $orderedChars[ $i ] . $letterfrequencies{$orderedChars[ $i ]} ) ;
   }
   return $outputstring ;
}

sub findFrequencies {
   my $input = shift ;
   my %letterfrequencies ;
   for my $i ( 0..length( $input ) - 1 ) {
      $letterfrequencies{substr( $input , $i , 1 ) }++ ;
   }
   return %letterfrequencies ;
}

sub mostFreqKSimilarity {
   my $first = shift ;
   my $second = shift ;
   my $similarity = 0 ;
   my %frequencies_first = findFrequencies( $first ) ;
   my %frequencies_second = findFrequencies( $second ) ;
   foreach my $letter ( keys %frequencies_first ) {
      if ( exists ( $frequencies_second{$letter} ) ) {
	 $similarity += ( $frequencies_second{$letter} + $frequencies_first{$letter} ) ;
      }
   }
   return $similarity ;
}

sub mostFreqKSDF {
   (my $input1 , my $input2 , my $k , my $maxdistance ) = @_ ;
   return $maxdistance - mostFreqKSimilarity( mostFreqHashing( $input1 , $k) ,
	 mostFreqHashing( $input2 , $k) ) ;
}

my $firststring = "LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV" ;
my $secondstring = "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG" ;
print "MostFreqKHashing ( " . '$firststring , 2)' . " is " . mostFreqHashing( $firststring , 2 ) . "\n" ;
print "MostFreqKHashing ( " . '$secondstring , 2)' . " is " . mostFreqHashing( $secondstring , 2 ) . "\n" ;
