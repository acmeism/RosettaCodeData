// post to the REPL directly
(
(99..0).do { |n|
	"% bottles of beer on the wall\n% bottles of beer\nTake one down, pass it around\n% bottles of beer on the wall\n".postf(n, n, n)
};
)

// post over time
(
fork {
	100.reverseDo { |n|
		n.post; " bottles of beer on the wall".postln; 0.5.wait;
		n.post; " bottles of beer".postln; 0.5.wait;
		"Take one down, pass it around".postln; 0.5.wait;
		n.post; " bottles of beer on the wall".postln; 0.5.wait;
		1.wait;
	};
}
)
