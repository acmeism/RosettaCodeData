Ingorabilis {

	tell {
		"I told you so".postln;
	}

	find {
		"I found nothing".postln
	}

	doesNotUnderstand { |selector ... args|
		"Method selector '%' not understood by %\n".postf(selector, this.class);
		"Giving you some good arguments in the following".postln;
		args.do { |x| x.postln };
		"And now I delegate the method to my respected superclass".postln;
		super.doesNotUnderstand(selector, args)
	}

}
