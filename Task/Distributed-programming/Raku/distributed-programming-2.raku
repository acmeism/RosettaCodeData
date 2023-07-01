#!/usr/bin/env raku
use JSON::Fast ;
multi MAIN('set', $topic,  $message='', :$server='localhost', :$port='3333', :$json='') {
    my %msg = function => 'set' , topic=> $topic , message=> $message ;
    %msg{"message"} = from-json( $json ) if $json ;
    sendmsg( %msg , $server, $port) ;
}
multi MAIN('get', $topic, :$server='localhost', :$port='3333') {
    my %msg = function => 'get' , topic=> $topic ;
    sendmsg( %msg , $server, $port) ;
}
multi MAIN('delete', $topic, :$server='localhost', :$port='3333') {
    my %msg = function => 'delete' , topic=> $topic ;
    sendmsg( %msg , $server, $port) ;
}
multi MAIN('dump', :$server='localhost', :$port='3333') {
    my %msg = function => 'dump'  ;
    sendmsg( %msg , $server, $port) ;
}
sub sendmsg( %msg , $server, $port){
    my $conn = await IO::Socket::Async.connect( $server , $port );
    $conn.print: to-json( %msg,:!pretty)~"\n";
    react {
        whenever $conn.Supply -> $data {
            print $data;
            $conn.close;
        }
    }
}
