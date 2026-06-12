# 20211209 Raku programming solution

use LWP::Simple;
use Compress::Bzip2;
use IO::Socket::SSL;

my $LanguageMark = "==French==";
my $Target       = 5; # words
my $URL          = 'https://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2';

class CustomLWP is LWP::Simple { has $.URL ;

   method CustomRequest {

      my Blob $resp          = Buf.new;
      my $bzip               = Compress::Bzip2::Stream.new;
      my ( $tail, %needles ) = '';

      my ($host, $port, $path) = self.parse_url($.URL)[1..3];
      my $sock = IO::Socket::SSL.new: :$host, :$port;

      $sock.print( "GET {$path} HTTP/1.1\r\n" ~ self.stringify_headers( {
         'Connection'  => 'close',
         'User-Agent'  => "LWP::Simple/{LWP::Simple::<$VERSION>} " ~
                          "Raku/{$*RAKU.compiler.gist}",
         'Host'        => $host
      } ) ~ "\r\n" ) or die ;       # request string

      while !self.got-header($resp) { $resp ~= $sock.read(2048) }

      my $bzip-stream = supply {
         emit self.parse_response($resp)[2]; # $resp_content @ parent class
         loop {
            done if %needles.elems >= $Target ;
            ( my $chunk = $sock.read(4096) ) ?? emit $chunk !! done
         }
      }

      react {
         whenever $bzip-stream -> $crypt {
            my $plain     = ( [~] $bzip.decompress: $crypt ).decode('utf8-c8');
            my @haystacks = $plain.split: "\n";
            @haystacks[0] = $tail ~ @haystacks[0];
            $tail         = @haystacks[*-1];

            my ($title,$got_text_last) = '', False ;

            for @haystacks[0..*-2] {
               if / '<title>' (\w+?) '</title>' / {
                  ($title,$got_text_last) = $0, False;
               } elsif /   '<text'     / {
                  $got_text_last = True
               } elsif / $LanguageMark / {
                  %needles{$title}++ if ( $got_text_last and $title.Bool );
                  last if ( %needles.elems >= $Target ) ;
                  $got_text_last = False;
               } elsif /  '</text>'    / { $got_text_last = False }
            }
         }
      }
      return %needles.keys[^$Target]
   }
}

my $ua = CustomLWP.new: URL => $URL ;

$ua.CustomRequest>>.say
