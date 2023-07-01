// create global canvas
var canvas = document.createElement('canvas');
canvas.id = 'globalCanvas';
document.body.appendChild(canvas);

function langtonant(antx, optx) {
	'use strict';
	var x, y, i;

	// extend default opts
	var opts = {
		gridsize: 100,
		pixlsize: 4,
		interval: 4
	};
	for (i in optx) {
		opts[i] = optx[i];
	}

	// extend default ants
	var ants = [{
		x: 50,
		y: 50,
		d: 0
	}];
	for (i in antx) {
		ants[i] = antx[i];
	}

	// initialise grid
	var grid = [];
	for (x = 0; x < opts.gridsize; x ++) {
		grid[x] = [];
		for (y = 0; y < opts.gridsize; y ++) {
			grid[x][y] = true;
		}
	}

	// initialise directions
	var dirs = [
		{x: 1, y: 0},
		{x: 0, y: -1},
		{x: -1, y: 0},
		{x: 0, y: 1}
	];

	// initialise canvas
	var canv = document.getElementById('globalCanvas');
	var cont = canv.getContext('2d');
	canv.width = opts.gridsize * opts.pixlsize;
	canv.height = opts.gridsize * opts.pixlsize;

	// initialise pixels
	var pixlblac = cont.createImageData(opts.pixlsize, opts.pixlsize);
	for (i = 0; i < (opts.pixlsize * opts.pixlsize * 4); i += 4) {
		pixlblac.data[i + 3] = 255;
	}
	var pixlwhit = cont.createImageData(opts.pixlsize, opts.pixlsize);
	for (i = 0; i < (opts.pixlsize * opts.pixlsize * 4); i += 4) {
		pixlwhit.data[i + 3] = 0;
	}

	// run simulation
	function simulate() {
		var sane = true;

		// iterate over ants
		for (i = 0; i < ants.length; i ++) {
			var n = ants[i];

			// invert, draw, turn
			if (grid[n.x][n.y]) {
				grid[n.x][n.y] = false;
				cont.putImageData(pixlblac, n.x * opts.pixlsize, n.y * opts.pixlsize);
				n.d --;
			} else {
				grid[n.x][n.y] = true;
				cont.putImageData(pixlwhit, n.x * opts.pixlsize, n.y * opts.pixlsize);
				n.d ++;
			}

			// modulus wraparound
			n.d += dirs.length;
			n.d %= dirs.length;

			// position + direction
			n.x += dirs[n.d].x;
			n.y += dirs[n.d].y;

			// sanity check
			sane = (n.x < 0 || n.x > opts.gridsize || n.y < 0 || n.y > opts.gridsize) ? false : sane;
		}

		// loop with interval
		if (sane) {
			setTimeout(simulate, opts.interval);
		}
	}

	simulate();
}
