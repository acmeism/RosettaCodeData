<?php

// Convert Hex Color to RGB

function hexrgb(&$h)
{
	return(array(hexdec($h[0].$h[1]),hexdec($h[2].$h[3]),hexdec($h[4].$h[5])));
}

// Allocate a color for an image from RGB

function rgbc(&$i, &$c)
{
	return(imagecolorallocate($i, $c[0], $c[1], $c[2]));
}

class Maze
{

/*
H : horizontal walls
V : vertical walls
x : number of rows
y : numbers of cols
r : resolve the maze
b : walls thickness
c : cell size
f : background color
m : walls color
e : entrance color
s : exit color
i : gd image identifier
*/

	private $H, $V, $x, $y, $r, $b, $c, $f, $m, $e, $s, $i;

// Initialize Maze class

	function __construct($x, $y, $r, $b, $c, $f, $m, $e, $s)
	{
		$this->x = $x;
		$this->y = $y;
		$this->r = $r;
		$this->b = $b;
		$this->c = $c;
		$this->f = hexrgb($f);
		$this->m = hexrgb($m);
		$this->e = hexrgb($e);
		$this->s = hexrgb($s);
	}

// Checks if cell is a closed room

	function isroom($x, $y)
	{
		return((empty($this->H[$x][$y])
			&& empty($this->V[$x][$y])
			&& empty($this->H[$x][$y+1])
			&& empty($this->V[$x+1][$y])) ? true : false);
	}

// Save the stack as solution path

	function save(&$x, &$y, &$m)
	{
		if ($this->r == 1 && $x == $this->x - 1 && $y == $this->y - 1)
		{
			$this->r = $m;
			array_push($this->r, array($x, $y));
		}
	}

// Dig the maze

	function dig()
	{
		$x = 0;
		$y = 0;
		$cc = $this->x * $this->y;
		$v = 1;
		$m = array();
		while ($v < $cc)
		{
			$c = '';
			if ($y > 0 && $this->isroom($x, $y - 1))
				$c .= 'N';
			if ($y < $this->y - 1 && $this->isroom($x, $y + 1))
				$c .= 'S';
			if ($x < $this->x - 1 && $this->isroom($x + 1, $y))
				$c .= 'E';
			if ($x > 0 && $this->isroom($x - 1, $y))
				$c .= 'W';
			if ($c)
			{
				$v++;
				array_push($m, array($x, $y));
				$d = $c[rand(0, strlen($c) - 1)];
				if ($d == 'N')
					$this->H[$x][$y--] = true;
				if ($d == 'S')
					$this->H[$x][$y++ + 1] = true;
				if ($d == 'E')
					$this->V[$x++ + 1][$y] = true;
				if ($d == 'W')
					$this->V[$x--][$y] = true;
			}
			else
				list($x, $y) = array_pop($m);
			$this->save($x, $y, $m);
		}
		$this->save($x, $y, $m);
		$this->V[0][0] = 1;
		$this->V[$this->x][$this->y - 1] = 1;
	}

// Draw the maze full grid

	function grid(&$m)
	{
		for ($y = 0; $y <= $this->y; ++$y)
		{
			imagefilledrectangle($this->i, 0, $y * ($this->c + $this->b),
				$this->b + $this->x * ($this->c + $this->b) - 1,
				$this->b + $y * ($this->c + $this->b) - 1,
				$m);
		}
		for ($x = 0; $x <= $this->x; ++$x)
		{
			imagefilledrectangle($this->i, $x * ($this->c + $this->b), 0,
				$this->b + $x * ($this->c + $this->b) - 1,
				$this->b + $this->y * ($this->c + $this->b) - 1,
				$m);
		}
	}

// Breaks the horizontal walls

	function line($x, $y, &$f)
	{
		imagefilledrectangle($this->i,
			$x * ($this->c + $this->b) + $this->b,
			$y * ($this->c + $this->b),
			$x * ($this->c + $this->b) + $this->b + $this->c - 1,
			$y * ($this->c + $this->b) + $this->b,
			$f);
	}

// Breaks the vertical walls

	function col($x, $y, &$f)
	{
		imagefilledrectangle($this->i,
			$x * ($this->c + $this->b),
			$y * ($this->c + $this->b) + $this->b,
			$x * ($this->c + $this->b) + $this->b,
			$y * ($this->c + $this->b) + $this->b + $this->c - 1,
			$f);
	}

// Breaks the walls

	function dot(&$f)
	{
		for ($x = 0; $x <= $this->x; ++$x)
		{
			for ($y = 0; $y <= $this->y; ++$y)
			{
				if (isset($this->H[$x][$y]))
					$this->line($x, $y, $f);
				if (isset($this->V[$x][$y]))
					$this->col($x, $y, $f);
			}
		}
	}

// Fill color cell

	function cellfill(&$x, &$y, &$c)
	{
		imagefilledrectangle($this->i,
			$x * ($this->c + $this->b) + $this->b,
			$y * ($this->c + $this->b) + $this->b,
			$x * ($this->c + $this->b) + $this->b + $this->c - 1,
			$y * ($this->c + $this->b) + $this->b + $this->c - 1,
			$c);
	}

// Draw solution

	function path()
	{
		$l = count($this->r);
		for ($i = 0; $i < $l; ++$i)
		{
			list($x, $y) = $this->r[$i];
			$r = ($this->e[0] * ($l - $i) + $this->s[0] * $i) / $l;
			$g = ($this->e[1] * ($l - $i) + $this->s[1] * $i) / $l;
			$b = ($this->e[2] * ($l - $i) + $this->s[2] * $i) / $l;
			if (!isset($c[$r][$g][$b]))
				$c[$r][$g][$b] = imagecolorallocate($this->i, $r, $g, $b);
			$this->cellfill($x, $y, $c[$r][$g][$b]);
			if (isset($ox, $oy))
			{
				if ($ox - $x == -1)
					$this->col($x, $y, $c[$r][$g][$b]);
				if ($oy - $y == -1)
					$this->line($x, $y, $c[$r][$g][$b]);
				if ($ox - $x == 1)
					$this->col($ox, $oy, $c[$r][$g][$b]);
				if ($oy - $y == 1)
					$this->line($ox, $oy, $c[$r][$g][$b]);
			}
			if ($i == 0)
				$this->col(0, 0, $c[$r][$g][$b]);
			if ($i == $l - 1)
				$this->col($x + 1, $y, $c[$r][$g][$b]);
			$ox = $x;
			$oy = $y;
		}
	}

// Call digger and make rendering

	function __destruct()
	{
		$this->dig();
		$this->i = imagecreatetruecolor(
			$this->b + $this->x * ($this->c + $this->b),
			$this->b + $this->y * ($this->c + $this->b));
		$f = rgbc($this->i, $this->f);
		$m = rgbc($this->i, $this->m);
		unset($this->f, $this->m);
		imagefill($this->i, 0, 0, $f);
		$this->grid($m);
		$this->dot($f);
		unset($f, $m, $this->H, $this->V);
		if ($this->r)
			$this->path();
		unset($this->r, $this->e, $this->s);
		header('content-disposition:inline;filename="maze.png"');
		header('cache-control:no-store,no-cache,must-revalidate');
		header('content-type:image/png');
		imagepng($this->i, NULL, 9, PNG_ALL_FILTERS);
		imagedestroy($this->i);
	}
}
