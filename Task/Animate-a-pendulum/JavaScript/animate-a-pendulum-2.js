<html>
	<head>
		<title>Swinging Pendulum Simulation</title>
	</head>
	<body><center>
		<svg id="scene" height="200" width="300">
			<line id="string" x1="150" y1="50" x2="250" y2="50" stroke="brown" stroke-width="4" />
			<circle id="ball" cx="250" cy="50" r="20" fill="black" />
		</svg>
		<br>
		Initial angle:<input id="in_angle" type="number" min="0" max="180" onchange="condReset()"/>(degrees)
		<br>
		<button type="button" onclick="startAnimation()">Start</button>
		<button type="button" onclick="stopAnimation()">Stop</button>
		<button type="button" onclick="reset()">Reset</button>
		<script>
			in_angle.value = 0;
			var cx = 150, cy = 50;
			var radius = 100; // cm
			var g = 981; // cm/s^2
			var angle = 0; // radians
			var vel = 0; // cm/s
			var dx = 0.02; // s
			var acc, vel, penx, peny;
			var timerFunction = null;
			function stopAnimation() {
				if(timerFunction != null){
					clearInterval(timerFunction);
					timerFunction = null;
				}
			}
			function startAnimation() {
				if(!timerFunction) timerFunction = setInterval(swing, dx * 1000);
			}
			function swing(){
				acc = g * Math.cos(angle) * dx;
				vel += acc * dx;
				angle += vel * dx;
				setPenPos();
			}
			function setPenPos(){
				penx = cx + radius * Math.cos(angle);
				peny = cy + radius * Math.sin(angle);
				scene.getElementById("string").setAttribute("x2", penx);
				scene.getElementById("string").setAttribute("y2", peny);
				scene.getElementById("ball").setAttribute("cx", penx);
				scene.getElementById("ball").setAttribute("cy", peny);
			}
			function reset(){
				var val = parseInt(in_angle.value)*0.0174532925199;
				if (val) angle = val;
				else angle = 0;
				acc = 0;
				vel = 0;
				setPenPos();
			}
			function condReset(){
				if (!timerFunction) reset();
			}
		</script>
	</body>
</html>
