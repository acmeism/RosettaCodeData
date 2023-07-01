{local$_=q{
{
    package Quine;
    use strict;
    use warnings;
    our $VERSION = sprintf "%d.%02d", q$Revision: 0.2 $ =~ /(\d+)/g;
    my $head = '{local$_=q' . "\x7B\n";
    my $tail = 'print"{local\$_=q{$_};eval}\n"' . "\x7D;eval}\n";

    sub new {
        my $class = shift;
        my $quine = $head . shift;
        my $ret   = shift || 1;
        my $ln    = ( $quine =~ tr/\n/\n/ );
        $ln++;
        $quine .= "return $ret if caller(1)or(caller)[2]!=$ln;$tail";
        bless \$quine, $class;
    }

    sub from_file {
        my ( $class, $fn, $ret ) = @_;
        local $/;
        open my $fh, '<', $fn or die "$fn : $!";
        my $src = <$fh>;
        close $fh;
        $class->new( $src, $ret );
    }

    sub quine { ${ $_[0] } }

=head1 NAME

Quine - turn your perl modules/apps into a true quine!

=head1 VERSION

$Id: Quine.pm,v 0.2 2010/09/15 20:23:53 dankogai Exp dankogai $

=head1 SYNOPSIS

  use Quine;
  print Quine->from_file("woot.pl")->quine;
  print Quine->from_file("moot.psgi", '$app')->quine;

=cut
}
return 1 if caller(1);print"{local\$_=q{$_};eval}\n"};eval}
