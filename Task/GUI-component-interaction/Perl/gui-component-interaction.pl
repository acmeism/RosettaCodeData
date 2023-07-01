#!/usr/bin/perl

use strict;
use warnings;
use Tk;
use Tk::Dialog;
use Tk::LabFrame;

my $value = 0;

my $mw = MainWindow->new;
$mw->title( 'GUI component interaction' );
my $lf = $mw->LabFrame( -label => 'Value' )->pack(-fill => 'x',-expand => 1);
$lf->Entry( -width => 10, -textvariable => \$value,
  -validate => 'key', -validatecommand => sub { $_[0] =~ /^\d{1,9}\z/ },
  )->pack(-fill => 'x', -expand => 1);
$mw->Button( -text => 'increment', -command => sub { $value++ },
  )->pack( -side => 'left' );
$mw->Button( -text => 'random', -command => sub {
  $mw->Dialog(
    -text => 'Change to a random value?',
    -title => 'Confirm',
    -buttons => [ qw(Yes No) ]
    )->Show eq 'Yes' and $value = int rand 1e9; }
  )->pack( -side => 'right' );

MainLoop;
