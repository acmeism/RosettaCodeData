use Lingua::EN::Sentence;

my $paragraph = q:to/PARAGRAPH/;
hi there, how are you today? I'd like to present to you the washing machine
9001. You have been nominated to win one of these! Just make sure you don't
break it


Just because there are punctuation characters like "?", "!" or especially "."
present, it doesn't necessarily mean you have reached the end of a sentence,
does it Mr. Magoo? The syntax highlighting here for Raku isn't the best.
PARAGRAPH

say join "\n\n", $paragraph.&sentences.map: {
    /(<:punct>)$/;
    $_ ~ ' | ' ~ do
    given $0 {
        when '!' { 'E' };
        when '?' { 'Q' };
        when '.' { 'S' };
        default  { 'N' };
    }
}
