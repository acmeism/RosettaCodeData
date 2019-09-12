push @{$anagram{ join '' => sort split '' }}, $_ for @words;
$max > @$_  or  $max = @$_    for values %anagram;
@$_ == $max and print "@$_\n" for values %anagram;
