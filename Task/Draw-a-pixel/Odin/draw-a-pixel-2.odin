package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(320, 240, "Rosetta Code - Draw a pixel")

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)

		rl.DrawPixelV({100, 100}, {255, 0, 0, 255})

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
