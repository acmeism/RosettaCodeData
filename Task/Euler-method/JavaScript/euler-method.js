// Function that takes differential-equation, initial condition,
// ending x, and step size as parameters
function eulersMethod(f, x1, y1, x2, h) {
	// Header
	console.log("\tX\t|\tY\t");
	console.log("------------------------------------");

	// Initial Variables
	var x=x1, y=y1;

	// While we're not done yet
	// Both sides of the OR let you do Euler's Method backwards
	while ((x<x2 && x1<x2) || (x>x2 && x1>x2)) {
		// Print what we have
		console.log("\t" + x + "\t|\t" + y);

		// Calculate the next values
		y += h*f(x, y)
		x += h;
	}

	return y;
}

function cooling(x, y) {
	return -0.07 * (y-20);
}

eulersMethod(cooling, 0, 100, 100, 10);
