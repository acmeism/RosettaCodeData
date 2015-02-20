class Kd_node {
    has $.d;
    has $.split;
    has $.left;
    has $.right;
}

class Orthotope {
    has $.min;
    has $.max;
}

class Kd_tree {
    has $.n;
    has $.bounds;
    method new($pts, $bounds) { self.bless(n => nk2(0,$pts), bounds => $bounds) }

    sub nk2($split, @e) {
        return () unless @e;
        my @exset = @e.sort(*.[$split]);
        my $m = +@exset div 2;
        my @d = @exset[$m][];
        while $m+1 < @exset and @exset[$m+1][$split] eqv @d[$split] {
            ++$m;
        }

        my $s2 = ($split + 1) % @d; # cycle coordinates
        Kd_node.new: :@d, :$split,
                left  => nk2($s2, @exset[0 ..^ $m]),
                right => nk2($s2, @exset[$m ^.. *]);
    }
}

class T3 {
    has $.nearest;
    has $.dist_sqd = Inf;
    has $.nodes_visited = 0;
}

sub find_nearest($k, $t, @p) {
    return nn($t.n, @p, $t.bounds, Inf);

    sub nn($kd, @target, $hr, $max_dist_sqd is copy) {
        return T3.new(:nearest([0.0 xx $k])) unless $kd;

        my $nodes_visited = 1;
        my $s = $kd.split;
        my $pivot = $kd.d;
        my $left_hr = $hr.clone;
        my $right_hr = $hr.clone;
        $left_hr.max[$s] = $pivot[$s];
        $right_hr.min[$s] = $pivot[$s];

        my $nearer_kd;
        my $further_kd;
        my $nearer_hr;
        my $further_hr;
        if @target[$s] <= $pivot[$s] {
            ($nearer_kd, $nearer_hr) = $kd.left, $left_hr;
            ($further_kd, $further_hr) = $kd.right, $right_hr;
        }
        else {
            ($nearer_kd, $nearer_hr) = $kd.right, $right_hr;
            ($further_kd, $further_hr) = $kd.left, $left_hr;
        }

        my $n1 = nn($nearer_kd, @target, $nearer_hr, $max_dist_sqd);
        my $nearest = $n1.nearest;
        my $dist_sqd = $n1.dist_sqd;
        $nodes_visited += $n1.nodes_visited;

        if $dist_sqd < $max_dist_sqd {
            $max_dist_sqd = $dist_sqd;
        }
        my $d = ($pivot[$s] - @target[$s]) ** 2;
        if $d > $max_dist_sqd {
            return T3.new(:$nearest, :$dist_sqd, :$nodes_visited);
        }
        $d = [+] (@$pivot Z- @target) X** 2;
        if $d < $dist_sqd {
            $nearest = $pivot;
            $dist_sqd = $d;
            $max_dist_sqd = $dist_sqd;
        }

        my $n2 = nn($further_kd, @target, $further_hr, $max_dist_sqd);
        $nodes_visited += $n2.nodes_visited;
        if $n2.dist_sqd < $dist_sqd {
            $nearest = $n2.nearest;
            $dist_sqd = $n2.dist_sqd;
        }

        T3.new(:$nearest, :$dist_sqd, :$nodes_visited);
    }
}

sub show_nearest($k, $heading, $kd, @p) {
    print qq:to/END/;
        $heading:
        Point:            [@p.join(',')]
        END
    my $n = find_nearest($k, $kd, @p);
    print qq:to/END/;
        Nearest neighbor: [$n.nearest.join(',')]
        Distance:         &sqrt($n.dist_sqd)
        Nodes visited:    $n.nodes_visited()

        END
}

sub random_point($k) { [rand xx $k] }
sub random_points($k, $n) { [random_point($k) xx $n] }

sub MAIN {
    my $kd1 = Kd_tree.new([[2, 3],[5, 4],[9, 6],[4, 7],[8, 1],[7, 2]],
                  Orthotope.new(:min([0, 0]), :max([10, 10])));
    show_nearest(2, "Wikipedia example data", $kd1, [9, 2]);

    my $N = 1000;
    my $t0 = now;
    my $kd2 = Kd_tree.new(random_points(3, $N), Orthotope.new(:min([0,0,0]), :max([1,1,1])));
    my $t1 = now;
    show_nearest(2,
        "k-d tree with $N random 3D points (generation time: {$t1 - $t0}s)",
         $kd2, random_point(3));
}
