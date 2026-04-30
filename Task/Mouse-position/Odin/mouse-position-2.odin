package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(320, 240, "Rosetta Code - Mouse position")

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)

		if rl.IsCursorOnScreen() do rl.DrawCircleV(rl.GetMousePosition(), 16, rl.RED)

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
