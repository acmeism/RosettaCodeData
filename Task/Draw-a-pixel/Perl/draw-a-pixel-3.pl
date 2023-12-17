#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Draw_a_pixel
use warnings;
use X11::Protocol;

my $x = new X11::Protocol or die "X11 connection failed";
$x->CreateWindow(my $id = $x->new_rsrc, $x->root, 'InputOutput',
	$x->root_depth, 'CopyFromParent',
	0, 0, 320, 240, 0,
	background_pixel => 0x000000,
	event_mask => $x->pack_event_mask( qw( Exposure )),
	);
$x->ChangeProperty($id, $x->atom('WM_NAME'), $x->atom('STRING'),
	8, 'Replace', 'Draw a Pixel');
$x->ChangeProperty($id, $x->atom('WM_PROTOCOLS'), $x->atom('ATOM'),
	32, 'Replace', pack('L', $x->atom('WM_DELETE_WINDOW')));
$x->CreateGC(my $gc = $x->new_rsrc, $id, foreground => 0xff0000);
$x->MapWindow($id);
$x->event_handler('queue');

my ($more, $name, %e) = 1;
while($more)
	{
	%e = $x->next_event;
	$name = $e{name};
	EVENT->$name;
	}

sub EVENT::Expose { $x->PolyPoint($id, $gc, 'ORIGIN', 100, 100) }
sub EVENT::ConfigureNotify { }
sub EVENT::ClientMessage
	{
	if($e{type} == $x->atom('WM_PROTOCOLS') &&
		unpack('L', $e{data}) == $x->atom('WM_DELETE_WINDOW'))
		{
		$more = 0;
		}
	else
		{
		warn "Unknown $name, $e{type}\n";
		}
	}
sub EVENT::AUTOLOAD { die "Sorry, no handler for $name\n" }
