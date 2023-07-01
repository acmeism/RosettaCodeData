#!/usr/bin/perl

use strict;
use warnings;
use Tk;
use Tk::Dialog;
use Tk::LabFrame;

my $value = 0;

my $mw = MainWindow->new;
$mw->title( 'GUI component enable/disable' );
my $lf = $mw->LabFrame( -label => 'Value' )->pack(-fill => 'x',-expand => 1);
my $entry = $lf->Entry( -width => 10, -textvariable => \$value,
  -validate => 'key', -validatecommand => sub {
  $_[0] =~ /^\d{1,9}\z/ ? do{setenable($_[0]); 1} : 0
  },
  )->pack(-fill => 'x', -expand => 1);
my $inc = $mw->Button( -text => 'increment',
  -command => sub { $value++; setenable($value) },
  )->pack( -side => 'left' );
my $dec = $mw->Button( -text => 'decrement',
  -command => sub { $value--; setenable($value) },
  )->pack( -side => 'right' );

setenable($value);

MainLoop;

sub setenable
  {
  $inc and $inc->configure( -state => $_[0] < 10 ? 'normal' : 'disabled' );
  $dec and $dec->configure( -state => $_[0] > 0 ? 'normal' : 'disabled' );
  $entry and $entry->configure( -state => $_[0] == 0 ? 'normal' : 'disabled' );
  }
