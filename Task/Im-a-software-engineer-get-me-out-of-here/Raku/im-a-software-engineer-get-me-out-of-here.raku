my $d = qq:to/END/;
         00000
      00003130000
    000321322221000
   00231222432132200
  0041433223233211100
  0232231612142618530
 003152122326114121200
 031252235216111132210
 022211246332311115210
00113232262121317213200
03152118212313211411110
03231234121132221411410
03513213411311414112320
00427534125412213211400
 013322444412122123210
 015132331312411123120
 003333612214233913300
  0219126511415312570
  0021321524341325100
   00211415413523200
    000122111322000
      00001120000
         00000
END

my $w = $d.split("\n")».chars.max;
$d = $d.split("\n")».fmt("%-{$w}s").join("\n"); # pad lines to same length
$w++;

my @directions = ( 1, -1, -$w-1, -$w, -$w+1, $w-1, $w, $w+1);
my @nodes.push: .pos - 1 for $d ~~ m:g/\d/;
my %dist = @nodes.race.map: { $_ => all-destinations([$_]) };

sub all-destinations (@queue) {
    my %to;
    my $dd = $d;
    while shift @queue -> $path {
        my $from = ($path.split(' '))[*-1];
        my $steps = $dd.substr($from, 1);
        next if $steps eq ' ';
        %to{$from} //= $path;
        next if $steps eq '0';
        $dd.substr-rw($from, 1) = '0';
        for @directions -> $dir {
            my $next = $from + $steps × $dir;
            next if $next < 0 or $next > $dd.chars;
            @queue.push: "$path $next" if $dd.substr($next, 1) ~~ /\d/;
        }
    }
    %to;
}

sub   to-xy ($nodes) { join ' ', $nodes.split(' ').map: { '(' ~ join(',', floor($_/$w), $_%$w) ~ ')' } }
sub from-xy ($x, $y) { $x × $w + $y }

my $startpos = from-xy 11, 11;

my %routes;
%routes{.split(' ').elems}.push: .&to-xy
    for grep { .so }, map { %dist{$startpos}{$_} }, grep { '0' eq $d.substr($_, 1) }, @nodes;
my $n = %routes{ my $short-route = %routes.keys.sort.first }.elems;
say "Shortest escape routes ($n) of length {$short-route - 1}:\n\t" ~
    %routes{$short-route}.join("\n\t");

say "\nShortest from (21,11) to  (1,11):\n\t" ~ %dist{from-xy 21, 11}{from-xy  1, 11}.&to-xy;
say "\nShortest from  (1,11) to (21,11):\n\t" ~ %dist{from-xy  1, 11}{from-xy 21, 11}.&to-xy;

my @long-short = reverse sort { .split(' ').elems }, gather %dist.deepmap(*.take);
my $l = @long-short[0].split(' ').elems;
say "\nLongest 'shortest' paths (length {$l-1}):";
say "\t" ~ .&to-xy for grep { .split(' ').elems == $l }, @long-short;

say "\nNot reachable from HQ:\n\t" ~ @nodes.grep({not %dist{$startpos}{$_}}).&to-xy;

my @HQ;
@HQ[.split(' ').elems].push: .&to-xy for %dist{$startpos}.values;
say "\nLongest reinforcement from HQ is {@HQ - 2} for:\n\t" ~ @HQ[*-1].join("\n\t");
