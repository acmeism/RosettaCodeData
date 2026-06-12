# 20211214 Perl programming solution

use strict;
use warnings;
use LWP::UserAgent;
use Compress::Raw::Bzip2 ;

my $LanguageMark = "==French==";
my $Target       = 5; # words
my $URL = 'https://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2';

my %needles; my $plain = my $tail = '';
my $ua = LWP::UserAgent->new;
my $bz = new Compress::Raw::Bunzip2({ -Bufsize => 1, -AppendOutput => 0 });

my $res = $ua->request( HTTP::Request->new(GET => $URL),
   sub { # @_ = Data Chunk, HTTP::Response
      foreach (split '', $_[0]) {
         my $status = $bz->bzinflate($_, substr($plain, 0)) ;
         last if $status == BZ_STREAM_END or $status != BZ_OK ;
      }

      if ( scalar ( my @haystacks = split "\n", $plain)) {
         $haystacks[0] = $tail . $haystacks[0];
         $tail         = $haystacks[$#haystacks];

         my ($title,$got_text_last) = '', 0 ;

         foreach ( @haystacks[0..$#haystacks-1] ) {
            if ( /<title>(\w+?)<\/title>/ ) {
               ($title,$got_text_last) = $1, 0;
            } elsif ( /<text/ ) {
               $got_text_last = 1;
            } elsif ( /$LanguageMark/ ) {
               $needles{$title}++ if ( $got_text_last and $title.defined );
               if ( %needles >= $Target ) {
                  print "$_\n" for sort keys %needles;
                  exit;
               }
               $got_text_last = 0;
            } elsif ( /<\/text>/ ) { $got_text_last = 0 }
         }
      }
   }
)
