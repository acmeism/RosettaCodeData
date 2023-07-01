var sec_old = 0;
function update_clock() {
	var t = new Date();
	var arms = [t.getHours(), t.getMinutes(), t.getSeconds()];
	if (arms[2] == sec_old) return;
	sec_old = arms[2];

	var c = document.getElementById('clock');
	var ctx = c.getContext('2d');
	ctx.fillStyle = "rgb(0,200,200)";
	ctx.fillRect(0, 0, c.width, c.height);
	ctx.fillStyle = "white";
	ctx.fillRect(3, 3, c.width - 6, c.height - 6);
	ctx.lineCap = 'round';

	var orig = { x: c.width / 2, y: c.height / 2 };
	arms[1] += arms[2] / 60;
	arms[0] += arms[1] / 60;
	draw_arm(ctx, orig, arms[0] * 30, c.width/2.5 - 15, c.width / 20,  "green");
	draw_arm(ctx, orig, arms[1] * 6,  c.width/2.2 - 10, c.width / 30,  "navy");
	draw_arm(ctx, orig, arms[2] * 6,  c.width/2.0 - 6,  c.width / 100, "maroon");
}

function draw_arm(ctx, orig, deg, len, w, style)
{
	ctx.save();
	ctx.lineWidth = w;
	ctx.lineCap = 'round';
	ctx.translate(orig.x, orig.y);
	ctx.rotate((deg - 90) * Math.PI / 180);
	ctx.strokeStyle = style;
	ctx.beginPath();
	ctx.moveTo(-len / 10, 0);
	ctx.lineTo(len, 0);
	ctx.stroke();
	ctx.restore();
}

function init_clock() {
	var clock = document.createElement('canvas');
	clock.width = 100;
	clock.height = 100;
	clock.id = "clock";
	document.body.appendChild(clock);

	window.setInterval(update_clock, 200);
}
