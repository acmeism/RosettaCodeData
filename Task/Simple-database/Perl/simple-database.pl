#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use JSON::PP;
use Time::Piece;

use constant {
    NAME     => 0,
    CATEGORY => 1,
    DATE     => 2,
    DB       => 'simple-db',
};

my $operation = shift // "";

my %dispatch = (
    n => \&add_new,
    l => \&print_latest,
    L => \&print_latest_for_categories,
    a => \&print_all,
);

if ($dispatch{$operation}) {
    $dispatch{$operation}->(@ARGV);
} else {
    die "Invalid option. Use one of n, l, L, a.\n"
}

sub add_new {
    my ($name, $category, $date) = @_;
    my $db = eval { load() } || {};
    if (defined $date) {
        eval { 'Time::Piece'->strptime($date, '%Y-%m-%d'); 1 }
            or die "Invalid date format: YYYY-MM-DD.\n";

    } else {
        $date //= localtime->ymd;
    }

    my @ids = keys %{ $db->{by_id} };
    my $max_id = max(num => @ids) || 0;
    $db->{by_id}{ ++$max_id } = [ $name, $category, $date ];
    save($db);
}

sub print_latest {
    build_indexes( my $db = load(), 0, 1 );
    _print_latest($db);
}

sub _print_latest {
    my ($db, $category) = @_;
    my @dates = keys %{ $db->{by_date} };
    @dates = grep {
        grep $db->{by_id}{$_}[CATEGORY] eq $category,
            @{ $db->{by_date}{$_} };
    } @dates if defined $category;

    my $last_date = max(str => @dates);
    say for map $db->{by_id}{$_}[NAME],
            grep ! defined $category
                 || $db->{by_id}{$_}[CATEGORY] eq $category,
            @{ $db->{by_date}{$last_date} };
}

sub max {
    my $type = shift;
    my $max = $_[0];
    { num => sub { $_ >  $max },
      str => sub { $_ gt $max},
    }->{$type}->() and $max = $_
        for @_[ 1 .. $#_ ];
    return $max
}

sub print_latest_for_categories {
    build_indexes( my $db = load(), 1, 1 );

    for my $category (sort keys %{ $db->{by_category} }){
        say "* $category";
        _print_latest($db, $category);
    }
}

sub print_all {
    build_indexes( my $db = load(), 0, 1 );

    for my $date (sort keys %{ $db->{by_date} }) {
        for my $id (@{ $db->{by_date}{$date} }) {
            say $db->{by_id}{$id}[NAME];
        }
    }
}

sub load {
    open my $in, '<', DB or die "Can't open database: $!\n";
    local $/;
    return { by_id => decode_json(<$in>) };
}

sub save {
    my ($db) = @_;
    open my $out, '>', DB or die "Can't save database: $!\n";
    print {$out} encode_json($db->{by_id});
    close $out;
}

sub build_indexes {
    my ($db, $by_category, $by_date) = @_;
    for my $id (keys %{ $db->{by_id} }) {
        push @{ $db->{by_category}{ $db->{by_id}{$id}[CATEGORY] } }, $id
            if $by_category;
        push @{ $db->{by_date}{ $db->{by_id}{$id}[DATE] } }, $id
            if $by_date;
    }
}
