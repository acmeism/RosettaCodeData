			document.getElementById('out').innerHTML= display({x: x, y: y, horiz: horiz, verti: verti, here: here});
			setTimeout(step, 100);
		}
	}
	step();
