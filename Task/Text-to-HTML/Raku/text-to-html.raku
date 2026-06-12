use Pod::To::HTML;
use HTML::Escape;

my $pod6 = q:to/POD6/;
=begin pod

A very simple Pod6 document.

This is a very high-level, hand-wavey overview. There are I<lots> of other
options available.

=head1 Section headings

=head1 A top level heading

=head2 A second level heading

=head3 A third level heading

=head4 A fourth level heading

=head1 Text

Ordinary paragraphs do not require an explicit marker or delimiters.

Alternatively, there is also an explicit =para marker that can be used to
explicitly mark a paragraph.

=para
This is an ordinary paragraph.
Its text  will   be     squeezed     and
short lines filled.

=head1 Code

Enclose code in a =code block (or V<C< >> markup for short, inline samples)

=begin code
    my $name = 'Rakudo';
    say $name;
=end code

=head1 Lists

=head3 Unordered lists

=item  Grumpy
=item  Dopey
=item  Doc
=item  Happy
=item  Bashful
=item  Sneezy
=item  Sleepy

=head3 Multi-level lists

=item1  Animal
=item2  Vertebrate
=item2  Invertebrate

=item1  Phase
=item2  Solid
=item2  Liquid
=item2  Gas

=head1 Formatting codes

Formatting codes provide a way to add inline mark-up to a piece of text.

All Pod6 formatting codes consist of a single capital letter followed
immediately by a set of single or double angle brackets; Unicode double angle
brackets may be used.

Formatting codes may nest other formatting codes.

There are many formatting codes available, some of the more common ones:

=item1 V<B< >> Bold
=item1 V<I< >> Italic
=item1 V<U< >> Underline
=item1 V<C< >> Code
=item1 V<L< >> Hyperlink
=item1 V<V< >> Verbatim (Don't interpret anything inside as POD markup)

=head1 Tables

There is quite extensive markup to allow rendering tables.

A simple example:

=begin table :caption<Mystery Men>
        The Shoveller   Eddie Stevens     King Arthur's singing shovel
        Blue Raja       Geoffrey Smith    Master of cutlery
        Mr Furious      Roy Orson         Ticking time bomb of fury
        The Bowler      Carol Pinnsler    Haunted bowling ball
=end table

=end pod
POD6

# for display on Rosettacode
say escape-html render($pod6);

# normally
#say render($pod6);
