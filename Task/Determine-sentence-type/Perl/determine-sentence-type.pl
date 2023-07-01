use strict;
use warnings;
use feature 'say';
use Lingua::Sentence;

my $para1 = <<'EOP';
hi there, how are you today? I'd like to present to you the washing machine
9001. You have been nominated to win one of these! Just make sure you don't
break it
EOP

my $para2 = <<'EOP';
Just because there are punctuation characters like "?", "!" or especially "."
present, it doesn't necessarily mean you have reached the end of a sentence,
does it Mr. Magoo? The syntax highlighting here for Perl isn't bad at all.
EOP

my $splitter = Lingua::Sentence->new("en");
for my $text ($para1, $para2) {
  for my $s (split /\n/, $splitter->split( $text =~ s/\n//gr ) {
    print "$s| ";
    if    ($s =~ /!$/)  { say 'E' }
    elsif ($s =~ /\?$/) { say 'Q' }
    elsif ($s =~ /\.$/) { say 'S' }
    else                { say 'N' }
  }
}
