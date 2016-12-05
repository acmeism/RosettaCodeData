// some useful functions
(
~grid = { 0 ! 60 } ! 60;

~at = { |coord|
	var col = ~grid.at(coord[0]);
	if(col.notNil) { col.at(coord[1]) }
};
~put = { |coord, value|
	var col = ~grid.at(coord[0]);
	if(col.notNil) { col.put(coord[1], value) }
};

~coord = ~grid.shape.rand;
~next = { |p|
	var possible = [p] + [[0, 1], [1, 0], [-1, 0], [0, -1]];
	possible = possible.select { |x|
		var c = ~at.(x);
		c.notNil and: { c == 0 }
	};
	possible.choose
};
~walkN = { |p, scale|
	var next = ~next.(p);
	if(next.notNil) {
		~put.(next, 1);
		Pen.lineTo(~topoint.(next, scale));
		~walkN.(next, scale);
		~walkN.(next, scale);
		Pen.moveTo(~topoint.(p, scale));
	};
};

~topoint = { |c, scale| (c + [1, 1] * scale).asPoint };

)

// do the drawing
(
var b, w;

b = Rect(100, 100, 700, 700);
w = Window("so-a-mazing", b);
w.view.background_(Color.black);

w.drawFunc = {
	var p = ~grid.shape.rand;
	var scale = b.width / ~grid.size * 0.98;
	Pen.moveTo(~topoint.(p, scale));
	~walkN.(p, scale);
	Pen.width = scale / 4;
	Pen.color = Color.white;
	Pen.stroke;
};
w.front.refresh;
)
