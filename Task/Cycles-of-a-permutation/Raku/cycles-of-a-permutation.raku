# one-line
sub infix:<➜> ($start, $end) {$start.fc.comb(/\w/).antipairs.hash{ $end.fc.comb(/\w/) } »+» 1}

# cycle
sub infix:<➰> ($start, $end) {
    my @one-line = flat ($end ➜ $start);
    my @index = flat 1..+@one-line;
    my ($index, @cycles) = 0;
    for @index {
        my $this = $_ - 1;
        while @one-line[$this] {
            my $next = @one-line[$this];
            @cycles[$index].push: @index[$this];
            @one-line[$this] = Nil;
            $this = $next - 1;
        }
        ++$index;
    }
    @cycles.grep: *.elems > 1
}

# order of a cycle
sub order (@cycles) { [lcm] @cycles }

# signature of a cycle
sub signature (@cycles) {
    (@cycles.elems %% 2 and all @@cycles».elems %% 2) ?? 1 !! -1
}

# apply a one-line transform
sub apply-o ($string, @oneline) { $string.comb[@oneline].join }

# apply a cyclical transform
sub apply-c ($string, @cycle) {
    my @string = flat '', $string.comb;
    @cycle.map: { @string[|$_].=rotate(-1) }
    @string.join
}

# Alf & Bettys letter arrangements
my %arrangment =
    :Mon<HANDYCOILSERUPT>,
    :Tue<SPOILUNDERYACHT>,
    :Wed<DRAINSTYLEPOUCH>,
    :Thu<DITCHSYRUPALONE>,
    :Fri<SOAPYTHIRDUNCLE>,
    :Sat<SHINEPARTYCLOUD>,
    :Sun<RADIOLUNCHTYPES>;

# some convenience variables
my @days = <Sun Mon Tue Wed Thu Fri Sat Sun>;
my @o = @days.rotor(2 => -1).map: { (%arrangment{.[0]} ➜ %arrangment{.[1]}) »-» 1 }
my @c = @days.rotor(2 => -1).map: { (%arrangment{.[0]} ➰ %arrangment{.[1]}) }

my $today;

# The task
say qq:to/ALF&BETTY/;
On Thursdays Alf and Betty should rearrange
their letters using these cycles:  {gist %arrangment<Wed> ➰ %arrangment<Thu>}

So that {%arrangment<Wed>} becomes {%arrangment<Wed>.&apply-o: (%arrangment<Wed> ➜ %arrangment<Thu>) »-» 1}

or they could use the one-line notation:  {gist %arrangment<Wed> ➜ %arrangment<Thu>}


To revert to the Wednesday arrangement they
should use these cycles:  {gist %arrangment<Thu> ➰ %arrangment<Wed>}

or with the one-line notation:  {gist %arrangment<Thu> ➜ %arrangment<Wed>}

So that {%arrangment<Thu>} becomes {%arrangment<Thu>.&apply-o: (%arrangment<Thu> ➜ %arrangment<Wed>) »-» 1}


Starting with the Sunday arrangement and applying each of the daily
permutations consecutively, the arrangements will be:

      {$today = %arrangment<Sun>}

{join "\n", @days[1..*].map: { sprintf "%s:  %s", $_, $today = $today.&apply-o: @o[$++] } }


To go from Wednesday to Friday in a single step they should use these cycles:
{gist %arrangment<Wed> ➰ %arrangment<Fri>}

So that {%arrangment<Wed>} becomes {%arrangment<Fri>}


These are the signatures of the permutations:

  Mon Tue Wed Thu Fri Sat Sun
  {@c.map(&signature)».fmt("%2d").join: '  '}

These are the orders of the permutations:

  Mon Tue Wed Thu Fri Sat Sun
  {@c.map(&order)».fmt("%2d").join: '  '}

Applying the Friday cycle to a string 10 times:

   {$today = 'STOREDAILYPUNCH'}

{join "\n", (1..10).map: {sprintf "%2d %s", $_, $today = $today.&apply-c: @c[4]} }
ALF&BETTY

say 'and one last transform:';
say 'STOREDAILYPUNCH'.&apply-c: [[<1 6 12 2 3 4 13 15 9 11 5 14 8 10 7>],];
