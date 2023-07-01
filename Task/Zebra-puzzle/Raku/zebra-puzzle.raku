my Hash @houses = (1 .. 5).map: { %(:num($_)) }; # 1 there are five houses

my @facts = (
    { :nat<English>, :color<red> },      # 2 The English man lives in the red house.
    { :nat<Swede>, :pet<dog> },          # 3 The Swede has a dog.
    { :nat<Dane>, :drink<tea> },         # 4 The Dane drinks tea.
    { :color<green>, :Left-Of(:color<white>) }, # 5 the green house is immediately to the left of the white house
    { :drink<coffee>, :color<green> },   # 6 They drink coffee in the green house.
    { :smoke<Pall-Mall>, :pet<birds> },  # 7 The man who smokes Pall Mall has birds.
    { :color<yellow>, :smoke<Dunhill> }, # 8 In the yellow house they smoke Dunhill.
    { :num(3), :drink<milk> },           # 9 In the middle house they drink milk.
    { :num(1), :nat<Norwegian> },        # 10 The Norwegian lives in the first house.
    { :smoke<Blend>, :Next-To(:pet<cats>) }, # 11 The man who smokes Blend lives in the house next to the house with cats.
    { :pet<horse>, :Next-To(:smoke<Dunhill>) }, # 12 In a house next to the house where they have a horse, they smoke Dunhill.
    { :smoke<Blue-Master>, :drink<beer> }, # 13 The man who smokes Blue Master drinks beer.
    { :nat<German>, :smoke<Prince> },      # 14 The German smokes Prince.
    { :nat<Norwegian>, :Next-To(:color<blue>) }, # 15 The Norwegian lives next to the blue house.
    { :drink<water>, :Next-To(:smoke<Blend>) },  # 16 They drink water in a house next to the house where they smoke Blend.
    { :pet<zebra> }, # who owns this?
);

sub MAIN {
    for gather solve(@houses, @facts) {
        #-- output
        say .head.sort.map(*.key.uc.fmt("%-9s")).join(' | ');
        say .sort.map(*.value.fmt("%-9s")).join(' | ')
            for .list;
        last; # stop after first solution
    }
}

#| a solution has been found that fits all the facts
multi sub solve(@solution, @facts [ ]) {
    take @solution;
}

#| extend this scenario to fit the next fact
multi sub solve(@scenario, [ $fact, *@facts ]) {
    for gather match(@scenario, |$fact) -> @houses {
        solve(@houses, @facts)
    }
}

#| find all possible solutions for pairs of houses with
#| properties %b, left of a house  with properties %a
multi sub match(@houses, :Left-Of(%a)!, *%b) {
    for 1 ..^ @houses {
        my %left-house  := @houses[$_-1];
        my %right-house := @houses[$_];

        if plausible(%left-house, %a) && plausible(%right-house, %b) {
            temp %left-house  ,= %a;
            temp %right-house ,= %b;
            take @houses;
        }
    }
}

#| match these houses are next to each other (left or right)
multi sub match(@houses, :Next-To(%b)!, *%a ) {
    match(@houses, |%a, :Left-Of(%b) );
    match(@houses, |%b, :Left-Of(%a) );
}

#| find all possible houses that match the given properties
multi sub match(@houses, *%props) {
    for @houses.grep({plausible($_, %props)}) -> %house {
        temp %house ,= %props;
        take @houses;
    }
}

#| plausible if doesn't conflict with anything
sub plausible(%house, %props) {
   ! %props.first: {%house{.key} && %house{.key} ne .value };
}
