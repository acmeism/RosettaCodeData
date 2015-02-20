$days = @{
    1 = "first";
    2 = "second";
    3 = "third";
    4 = "fourth";
    5 = "fifth";
    6 = "sixth";
    7 = "seventh";
    8 = "eight";
    9 = "ninth";
    10 = "tenth";
    11 = "eleventh";
    12 = "twelfth";
}

$gifts = @{
    1 = 'A partridge in a pear tree';
    2 = 'Two turtle doves';
    3 = 'Three french hens';
    4 = 'Four calling birds';
    5 = 'Five golden rings';
    6 = 'Six geese a-laying';
    7 = 'Seven swans a-swimming';
    8 = 'Eight maids a-milking';
    9 = 'Nine ladies dancing';
    10 = 'Ten lords a-leaping';
    11 = 'Eleven pipers piping';
    12 = 'Twelve drummers drumming';
}

1 .. 12 | % {
    "On the $($days[$_]) day of Christmas`nMy true love gave to me"
    $_ .. 1 | % {
        $gift = $gifts[$_]
        if ($_ -eq 2) { $gift += " and" }
        $gift
    }
    ""
}
