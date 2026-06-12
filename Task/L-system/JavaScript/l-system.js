	class LSystem {
	    static main() {
	        const axiom = "A";
	        // Replacing List.of with an array of objects
	        const rules = [
	            { source: "A", target: "AB" },
	            { source: "B", target: "A" }
	        ];
	        const iterations = 7;
	        console.log(this.lindenmayer(axiom, rules, iterations));
	    }
	    static lindenmayer(axiom, rules, iterations) {
	        let result = axiom;
	        for (let i = 0; i < iterations; i++) {
	            let builder = "";
	            // In Java, "AB".split("") splits into ["A", "B"],
	            // but in JS it splits into ["A", "B", ""] if not handled carefully.
	            // Using [...result] or spread syntax is the JS equivalent to split("").
	            for (const letter of [...result]) {
	                for (const rule of rules) {
	                    if (letter === rule.source) {
	                        builder += rule.target;
	                    }
	                }
	            }
	            result = builder;
	        }
	        return result;
	    }
	}
	// Execute the main method
	LSystem.main();
