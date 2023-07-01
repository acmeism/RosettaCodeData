#!/usr/bin/perl

use strict; # http://www.rosettacode.org/wiki/Chat_server
use warnings;
use IO::Socket;
use IO::Select; # with write queueing

my $port = shift // 6666;
my (%nicks, @users, %data);

my $listen = IO::Socket::INET->new(LocalPort => $port, Listen => 9,
  Reuse => 1) or die "$@ opening socket on port $port";
my $rsel = IO::Select->new($listen);
my $wsel = IO::Select->new();
print "ready on $port...\n";

sub to
  {
  my $text = pop;
  for ( @_ )
    {
    length $data{$_}{out} or $wsel->add( $_ );
    length( $data{$_}{out} .= $text ) > 1e4 and left( $_ );
    }
  return $text;
  }

sub left
  {
  my $h = shift;
  @users = grep $h != $_, @users;
  if( defined( my $nick = delete $nicks{$h} ) )
    {
    print to @users, "$nick has left\n";
    }
  delete $data{$h};
  $rsel->remove($h);
  }

while( 1 )
  {
  my ($reads, $writes) = IO::Select->select($rsel, $wsel, undef, 5);
  for my $h ( @{ $writes // [] } )
    {
    my $len = syswrite $h, $data{$h}{out};
    $len and substr $data{$h}{out}, 0, $len, '';
    length $data{$h}{out} or $wsel->remove( $h );
    }
  for my $h ( @{ $reads // [] } )
    {
    if( $h == $listen )                                    # new connection
      {
      $rsel->add( my $client = $h->accept );
      $data{$client} = { h => $client, out => "enter nick: ", in => '' };
      $wsel->add( $client );
      }
    elsif( not sysread $h, $data{$h}{in}, 4096, length $data{$h}{in} ) # closed
      {
      left $h;
      }
    elsif( exists $nicks{$h} )                             # user is signed in
      {
      my @others = grep $h != $_, @users;
      to @others, "$nicks{$h}> $&" while $data{$h}{in} =~ s/.*\n//;
      }
    elsif( $data{$h}{in} =~ s/^(\w+)\r?\n.*//s and
      not grep lc $1 eq lc, values %nicks )
      {                                                    # user has joined
      my $all = join ' ', sort values %nicks;
      $nicks{$h} = $1;
      push @users, $h;
      print to @users, "$nicks{$h} has joined $all\n";
      }
    else                                                   # bad nick
      {
      to $h, "nick invalid or in use, enter nick: ";
      $data{$h}{in} = '';
      }
    }
  }
