#!/usr/bin/env raku
use JSON::Fast ;
sub MAIN( :$server='0.0.0.0', :$port=3333, :$dbfile='db' ) {
    my %db;
    my %index;
    my $dbdata = slurp "$dbfile.json" ;
    my $indexdata = slurp "{$dbfile}_index.json" ;
    %db = from-json($dbdata) if $dbdata ;
    %index = from-json($indexdata) if $indexdata ;
  react {
    whenever IO::Socket::Async.listen( $server , $port ) -> $conn {
        whenever $conn.Supply.lines -> $line {
            my %response = 'status' => '' ;
            my $msg = from-json $line ;
            say $msg.perl ;
            given $msg<function> {
                when 'set' {
                    %db{ $msg<topic> } = $msg<message> ;
                    %response<status> = 'ok' ;
                    %index<last_> = $msg<topic> ;
                    for %index<keys_>.keys -> $key {
                        if $msg<message>{$key} {
                            %index<lastkey_>{ $key }{ $msg<message>{$key} } = $msg<topic> ;
                            %index<idx_>{ $key }{ $msg<message>{$key} }{ $msg<topic> } = 1 ;
                        }
                    }
                    spurt "$dbfile.json", to-json(%db);
                    spurt "{$dbfile}_index.json", to-json(%index);
                }
                when 'get' {
                    %response<topic> = $msg<topic> ;
                    %response<message> = %db{ $msg<topic> } ;
                    %response<status> = 'ok' ;
                }
                when 'dump' {
                    %response{'data'} = %db ;
                    %response<status> = 'ok' ;
                }
                when 'dumpindex' {
                    %response{'data'} = %index ;
                    %response<status> = 'ok' ;
                }
                when 'delete' {
                    %db{ $msg<topic> }:delete;
                    %response<status> = 'ok' ;
                    spurt "$dbfile.json", to-json(%db);
                    reindex();
                }
                when 'addindex' {
                    %response<status> = 'ok' ;
                    %index<keys_>{ $msg<key>} =1 ;
                    reindex();
                }
                when 'reportlast' {
                    %response{'data'} = %db{%index<last_>} ;
                    %response<status> = 'ok' ;
                }
                when 'reportlastindex' {
                    %response<key> = $msg<key> ;
                    for %index<lastkey_>{$msg<key>}.keys -> $value {
                        #%response{'data'}.push: %db{ %index<lastkey_>{ $msg<key>  }{ $value } } ;
                        %response{'data'}{$value} = %db{ %index<lastkey_>{ $msg<key>  }{ $value } } ;
                    }
                    %response<status> = 'ok' ;
                }
                when 'reportindex' {
                    %response<status> = 'ok' ;
                    for %index<idx_>{$msg<key>}.keys.sort -> $value  {
                        for %index<idx_>{ $msg<key> }{ $value }.keys.sort -> $topic {
                            %response<data>.push:  %db{ $topic }  ;
                            #%response<data>{$value} = %db{ $topic }  ;
                        }
                    }
                }
                when 'commit' {
                    spurt "$dbfile.json", to-json(%db);
                    spurt "{$dbfile}_index.json", to-json(%index);
                    %response<status> = 'ok' ;
                }
                default {
                    %response<status> = 'error';
                    %response<error> = 'no function or not supported';
                }
            }
            $conn.print( to-json(%response, :!pretty) ~ "\n" ) ;
            LAST { $conn.close ; }
            QUIT { default { $conn.close ; say "oh no, $_";}}
            CATCH { default { say .^name, ': ', .Str ,  " handled in $?LINE";}}
        }
    }
  }
    sub reindex {
        %index<idx_>:delete;
        for %db.keys -> $topic {
            my $msg = %db{$topic} ;
            for %index<keys_>.keys -> $key {
                if $msg{$key} {
                    %index<idx_>{ $key }{ $msg{$key} }{ $topic } = 1 ;
                }
            }
        }
        spurt "{$dbfile}_index.json", to-json(%index) ;
    }
}
