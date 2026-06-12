my @lists = 1..9, 10..18, 19..27;
put [Z~] @lists;         # the task
put [Z~] @lists».flip;   # each component reversed
put [RZ~] @lists;        # in reversed order
put ([Z~] @lists)».flip; # reversed components in reverse order
