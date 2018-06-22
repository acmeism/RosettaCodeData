#!/usr/bin/env perl6
use JSON::Fast ;
sub MAIN( :$server='0.0.0.0' , :$port=3333 ) {
  my %db ;
  react {
    whenever IO::Socket::Async.listen( $server , $port ) -> $conn {
        whenever $conn.Supply.lines -> $line {
            my %response = 'status' => '' ;
            my $msg = from-json $line ;
            say $msg.perl ;
            given $msg{"function"} {
                when 'set' {
                    %db{ $msg<topic> } = $msg<message> ;
                    %response<status> = 'ok' ;
                }
                when 'get' {
                    %response<topic> = $msg<topic> ;
                    %response<message> = %db{ $msg<topic> } ;
                    %response<status> = 'ok' ;
                }
                when 'dump' {
                    %response = %db ;
                }
                when 'delete' {
                    %db{ $msg<topic> }:delete;
                    %response<status> = 'ok' ;
                }
            }
            $conn.print( to-json(%response, :!pretty) ~ "\n" ) ;
            LAST { $conn.close ; }
            QUIT { default { $conn.close ; say "oh no, $_";}}
            CATCH { default { say .^name, ': ', .Str ,  " handled in $?LINE";}}
        }
    }
  }
}
