(
var n = 12, s = "", t, c;

// Compute all values
t = Array.fill2D(n + 1, n + 1, {|x, y| x*y});

// Generate displayable string for
//   > header
n.do{|x| s = s ++ (x + 1).asString ++ "\t"}; s = s ++ "\n";
n.do{s = s ++ "___\t"}; s = s ++ "\n";

//   > main content
n.do{|y|
	n.do{|x|
		if(x >= y){c = t[x + 1][y + 1].asString}{c = " "};
		s = s ++ c ++ "\t";
	};
	s = s ++ "| " ++ (y + 1).asString ++ "\n";
};

s.postln; nil
)
