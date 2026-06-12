# 20201023 added Perl programming solution

use strict;
use warnings;

use Pod::Simple::HTML;

# POD example taken from https://juerd.nl/site.plp/perlpodtut
my $pod = <<'POD';
=head1 NAME

My::Module - An example module

=head1 SYNOPSIS

    use My::Module;
    my $object = My::Module->new();
    print $object->as_string;

=head1 DESCRIPTION

This module does not really exist, it
was made for the sole purpose of
demonstrating how POD works.

=head2 Methods

=over 12

=item C<new>

Returns a new My::Module object.

=item C<as_string>

Returns a stringified representation of
the object. This is mainly for debugging
purposes.

=back

=head1 LICENSE

This is released under the Artistic
License. See L<perlartistic>.

=head1 AUTHOR

Juerd - L<http://juerd.nl/>

=head1 SEE ALSO

L<perlpod>, L<perlpodspec>

=cut
POD

my $parser = Pod::Simple::HTML->new();
$parser->output_fh(*STDOUT);
$parser->parse_string_document($pod)
