function looptest(start, stop, step) {
	let a = [];
	try {
		for(let i = start; i <= stop; i += step) {
			a.push(i);
			if (a.length == 10) {
				break;
			}
		}
		return a;
	} catch {
		return "Not allowed";
	} 	
}

let test_cases = {"Normal": [-2, 2, 1],
                  "Zero step": [-2, 2, 0],
			      "Steps away from stop value": [-2, 2, -1],
				  "Step value > stop value": [-2, 2, 10],
				  "Start > stop, positive step": [2, -2, 1],
				  "Start = stop, positive step": [2, 2, 1],
				  "Start = stop, negative step": [2, 2, -1],
				  "Start = stop, zero step": [2, 2, 0],
				  "Start, stop, step all zero": [0, 0, 0]}

for (const property in test_cases) {
	let result = looptest(...test_cases[property]);
	console.log(`${property}: ${result} ${result.length == 10 ? "(loops forever)" : ""}`);
}
