class Square {
    has Complex ($.position, $.edge);
    method size { $!edge.abs }
    method svg-polygon {
	qq[<polygon points="{join ' ', map
	{ ($!position + $_ * $!edge).reals.join(',') },
	0, 1, 1+1i, 1i}" style="fill:lime;stroke=black" />]
    }
    method left-child {
	self.new:
	position => $!position + i*$!edge,
	edge => sqrt(2)/2*cis(pi/4)*$!edge;
    }
    method right-child {
	self.new:
	position => $!position + i*$!edge + self.left-child.edge,
	edge => sqrt(2)/2*cis(-pi/4)*$!edge;
    }
}

BEGIN say '<svg width="500" height="500">';
END   say '</svg>';

sub tree(Square $s, $level = 0) {
    return if $level > 8;
    say $s.svg-polygon;
    tree($s.left-child, $level+1);
    tree($s.right-child, $level+1);
}

tree Square.new: :position(250+0i), :edge(60+0i);
