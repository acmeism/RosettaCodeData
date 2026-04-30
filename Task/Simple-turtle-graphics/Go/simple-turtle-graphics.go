package main

import (
	"math"
	"slices"

	rl "github.com/gen2brain/raylib-go/raylib"
)

const (
	WIDTH  = 800
	HEIGHT = 600
)

type Turtle struct {
	angle     int
	X         int
	Y         int
	isPenDown bool
	penColor  rl.Color
}

func deg2Rad(degrees int) float64 {
	return float64(degrees) * math.Pi / 180
}

func (self *Turtle) Right(angle int) {
	self.angle = (self.angle + angle) % 360
}

func (self *Turtle) Left(angle int) {
	self.angle = (self.angle - angle) % 360
}

func (self *Turtle) SetPenColor(color rl.Color) {
	self.penColor = color
}

func (self *Turtle) PenUp() {
	self.isPenDown = false
}

func (self *Turtle) PenDown() {
	self.isPenDown = true
}

func (self *Turtle) line(x0, y0, x1, y1 int) {
	dx := x1 - x0
	if dx < 0 {
		dx = -dx
	}
	dy := y1 - y0
	if dy < 0 {
		dy = -dy
	}
	var sx, sy int
	if x0 < x1 {
		sx = 1
	} else {
		sx = -1
	}
	if y0 < y1 {
		sy = 1
	} else {
		sy = -1
	}
	err := dx - dy

	for {
		rl.DrawPixel(int32(x0), int32(y0), self.penColor)
		if x0 == x1 && y0 == y1 {
			break
		}
		e2 := 2 * err
		if e2 > -dy {
			err -= dy
			x0 += sx
		}
		if e2 < dx {
			err += dx
			y0 += sy
		}
	}
}
func (self *Turtle) Forward(length int) {
	endX := self.X - int(math.Round(float64(-length)*math.Cos(deg2Rad(self.angle))))
	endY := self.Y - int(math.Round(float64(-length)*math.Sin(deg2Rad(self.angle))))

	if self.isPenDown {
		self.line(self.X, self.Y, endX, endY)
	}

	self.X = endX
	self.Y = endY
}

func (self *Turtle) Backward(length int) {
	self.Forward(-length)
}

func triangle(turtle *Turtle, size int) {
	for range 3 {
		turtle.Forward(size)
		turtle.Right(120)
	}
}

func rectangle(turtle *Turtle, w int, h int) {
	for range 2 {
		turtle.Forward(h)
		turtle.Left(90)
		turtle.Forward(w)
		turtle.Left(90)
	}
}

func square(turtle *Turtle, size int) {
	rectangle(turtle, size, size)
}

func house(turtle *Turtle, size int) {
	turtle.Right(180)
	square(turtle, size)
	triangle(turtle, size)
	turtle.Right(180)
}

func barchart(turtle *Turtle, items []float64, size int) {
	scale := float64(size) / slices.Max(items)
	width := size / len(items)

	for _, i := range items {
		rectangle(turtle, int(i*scale), width)
		turtle.PenUp()
		turtle.Forward(width)
		turtle.PenDown()
	}

	turtle.PenUp()
	turtle.Backward(size)
	turtle.PenDown()
}

func main() {
	rl.InitWindow(WIDTH, HEIGHT, "Turtle")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		rl.ClearBackground(rl.Black)
		rl.BeginDrawing()

		turtle := Turtle{angle: 0, X: WIDTH / 2, Y: HEIGHT / 2, isPenDown: true}
		turtle.SetPenColor(rl.White)

		house(&turtle, 150)

		turtle.PenUp()
		turtle.Forward(10)
		turtle.PenDown()

		barchart(&turtle, []float64{0.5, (1.0 / 3.0), 2.0, 1.3, 0.5}, 200)

		turtle.PenUp()
		turtle.Backward(10)

		rl.EndDrawing()
	}
}
