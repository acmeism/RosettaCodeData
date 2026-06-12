package main

import (
	rl "github.com/gen2brain/raylib-go/raylib"
	m "math"
)

//Window size.
const wSize = 800
//Spinner radius/length.
const sRadius = 100
const sOffset = sRadius * 2
const speed = 250

type spinner struct {
	pos rl.Vector2
	colour rl.Color
}

//Returns a pointer to a new spinner.
func newSpinner(x float32, y float32, colour rl.Color) *spinner {
	s := spinner{pos: rl.NewVector2(x, y), colour: colour}
	return &s
}

//Calculates the end position of a given spinner.
func endPos(pos rl.Vector2, angle float64) rl.Vector2 {
	convertedAngle := angle * (m.Pi / 180)

	v := rl.NewVector2(
		pos.X + sRadius * float32(m.Cos(convertedAngle)),
		pos.Y + sRadius * float32(m.Sin(convertedAngle)) )

	return v
}

func main() {
	rl.InitWindow(wSize, wSize, "Spinner")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)
	rl.SetConfigFlags(rl.FlagMsaa4xHint)

	var angle float64 = 0.0
	const half = wSize / 2

	var spinnerLst = [5]*spinner{
		newSpinner(half, half, rl.Green),
		newSpinner(half - sOffset, half + sOffset, rl.White),
		newSpinner(half - sOffset, half - sOffset, rl.Red),
		newSpinner(half + sOffset, half + sOffset, rl.Yellow),
		newSpinner(half + sOffset, half - sOffset, rl.Orange) }

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.LightGray)
		rl.DrawCircle(half, half, half, rl.Black)

		for i := 0; i < 5; i++ {
			s := spinnerLst[i]

			rl.DrawLineEx(s.pos, endPos(s.pos, angle), 1, s.colour)
		}

		angle = m.Mod(angle + speed, 360)

		rl.EndDrawing()
	}
}
