constant DEBUG = 1;

my @lines = ([.ords X+& 1] for lines);  # The low bits Just Work.
my \v = +@lines;
my \h = +@lines[0];
my @black = flat @lines.map: *.values;   # Flatten to 1-dimensional.

my \p8 = [-h-1, -h+0, -h+1,         # Flatland distances to 8 neighbors.
           0-1,        0+1,
           h-1,  h+0,  h+1].[1,2,4,7,6,5,3,0];   # (in cycle order)

# Candidates have 8 neighbors and are known black
my @cand = grep { @black[$_] }, do
    for 1..v-2 X 1..h-2 -> (\y,\x) { y*h + x }

repeat while my @goners1 or my @goners2 {
    sub seewhite (\w1,\w2) {
        sub cycles (@neighbors) { [+] @neighbors Z< @neighbors[].rotate }
        sub blacks (@neighbors) { [+] @neighbors }

        my @prior = @cand; @cand = ();

        gather for @prior -> \p {
            my \n = @black[p8 X+ p];
            if cycles(n) == 1 and 2 <= blacks(n) <= 6 and n[w1].any == 0 and n[w2].any == 0
                 { take p }
            else { @cand.push: p }
        }
    }

    @goners1 = seewhite (0,2,4), (2,4,6);
    @black[@goners1] = 0 xx *;
    say "Ping: {[+] @black} remaining after removing ", @goners1 if DEBUG;

    @goners2 = seewhite (0,2,6), (0,4,6);
    @black[@goners2] = 0 xx *;
    say "Pong: {[+] @black} remaining after removing ", @goners2 if DEBUG;
}

say @black.splice(0,h).join.trans('01' => '.#') while @black;
