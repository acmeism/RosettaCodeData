use LWP::Simple;

for (split ' ' => get 'http://www.puzzlers.org/pub/wordlists/unixdict.txt')
    {push @{$anagram{ join '' => sort split // }}, $_}

$max > @$_  or  $max = @$_    for values %anagram;
@$_ >= $max and print "@$_\n" for values %anagram;
