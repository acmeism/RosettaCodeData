(
a = TaskProxy { |envir|
	envir.use {
		~integral = 0;
		~time = 0;
		~prev = 0;
		~running = true;
		loop {
			~val = ~input.(~time);
			~integral = ~integral + (~val + ~prev * ~dt / 2);
			~prev = ~val;
			~time = ~time + ~dt;
			~dt.wait;
		}
	}
};
)

// run the test
(
fork {
	a.set(\dt, 0.0001);
	a.set(\input, { |t| sin(2pi * 0.5 * t) });
	a.play(quant: 0); // play immediately
	2.wait;
	a.set(\input, 0);
	0.5.wait;
	a.stop;
	a.get(\integral).postln; // answers -7.0263424372343e-15
}
)
