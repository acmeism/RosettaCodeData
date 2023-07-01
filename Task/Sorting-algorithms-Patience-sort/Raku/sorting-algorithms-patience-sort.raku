multi patience(*@deck) {
    my @stacks;
    for @deck -> $card {
        with @stacks.first: $card before *[*-1] -> $stack {
            $stack.push: $card;
        }
        else {
            @stacks.push: [$card];
        }
    }
    gather while @stacks {
        take .pop given min :by(*[*-1]), @stacks;
        @stacks .= grep: +*;
    }
}

say ~patience ^10 . pick(*);
