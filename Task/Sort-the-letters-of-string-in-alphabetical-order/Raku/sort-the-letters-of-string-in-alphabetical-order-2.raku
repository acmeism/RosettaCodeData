sub moronic-sort ($string is copy) {
    my $chars = $string.chars;
    loop {
        for ^$chars {
            if ($string.substr($_, 1).fc gt $string.substr($_ + 1, 1).fc and $string.substr($_ + 1, 1) ~~ /<:L>/)
               or $string.substr($_, 1) ~~ /<:!L>/ {
                $string = $string.substr(0, $_) ~ $string.substr($_ , 2).flip ~ $string.substr($_ + 2 min $chars);
            }
        }
        last if $++ >= $chars;
    }
    $string
}

sub wrap ($whatever) { '»»' ~ $whatever ~ '««' }


# Test sort the exact string as specified in the task title.
say "moronic-sort 'string'\n" ~ wrap moronic-sort 'string';


# Other tests demonstrating the extent of the stupidity of this task.
say "\nLonger test sentence\n" ~
wrap moronic-sort q[This is a moronic sort. It's only concerned with sorting letters, so everything else is pretty much ignored / pushed to the end. It also doesn't much care about letter case, so there is no upper / lower case differentiation.];


say "\nExtended test string:\n" ~ my $test = (32..126)».chr.pick(*).join;
say wrap moronic-sort $test;
