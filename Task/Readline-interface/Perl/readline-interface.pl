use strict;
use warnings;
use Term::ReadLine;
use POSIX;

my $term = Term::ReadLine->new( 'simple Perl shell' );
my $attribs = $term->Attribs;
$attribs->{completion_append_character}     = ' ';
$attribs->{attempted_completion_function}   = \&attempt_perl_completion;
$attribs->{completion_display_matches_hook} = \&perl_symbol_display_match_list;

while (defined(my $command = &reader)) {
    my @result = eval ("package main; $command");
    print "$_\n" for @result;
}

sub reader {
    my $command = $term->readline('> ');
    $term->addhistory($command) if $command;
    $command;
}

sub perl_symbol_display_match_list {
    my($matches, $num_matches, $max_length) = @_;
    map { $_ =~ s/^((\$#|[\@\$%&])?).*::(.+)/$3/; }(@{$matches});
    $term->display_match_list($matches);
    $term->forced_update_display;
}

sub attempt_perl_completion {
    my ($text, $line, $start, $end) = @_;
    $term->completion_matches($text, \&perl_symbol_completion_function);
}

use vars qw($i @matches $prefix);
sub perl_symbol_completion_function {
    my($text, $state) = @_;
    my %type = ('$' => 'SCALAR', '*' => 'SCALAR', '@' => 'ARRAY', '$#' => 'ARRAY', '%' => 'HASH', '&' => 'CODE');

    if ($state) {
        $i++;
    } else {
        my ($pre, $pkg, $sym);
        $i = 0;

        no strict qw(refs);
        ($prefix, $pre, $pkg) = ($text =~ m/^((\$#|[\@\$%&])?(.*::)?)/);
        @matches = grep /::$/, $pkg ? keys %$pkg : keys %::;
        $pkg = '::' unless $pkg;
        @matches = (@matches, grep (/^\w+$/ && ($sym = $pkg . $_, defined *$sym{$type{$pre}}), keys %$pkg));
    }
    my $entry;
    for (; $i <= $#matches; $i++) {
        $entry = $prefix . $matches[$i];
        return $entry if ($entry =~ /^\Q$text/);
    }
    undef;
}
