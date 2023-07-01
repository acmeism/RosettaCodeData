use v6;
my @cities =
    ['UK', 'London'],
    ['US', 'New York'],
    ['US', 'Birmingham'],
    ['UK', 'Birmingham'],
    ;

.say for @cities.sort: { .[1] };
