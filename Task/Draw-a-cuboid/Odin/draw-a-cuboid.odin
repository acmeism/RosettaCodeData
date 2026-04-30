package cuboid

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(640, 480, "Rosetta Code - draw a cuboid")

	camera: rl.Camera3D
	camera.fovy = 45
	camera.position = {0, 5, 10}
	camera.up = {0, 1, 0}

	for !rl.WindowShouldClose() {
		rl.UpdateCamera(&camera, .ORBITAL)
		
		rl.BeginDrawing()

		rl.ClearBackground(rl.RAYWHITE)

		rl.BeginMode3D(camera)

		rl.DrawGrid(25, .5)

		cube := rl.Vector3 {2, 3, 4}

		rl.DrawCubeV({}, cube, rl.LIME)
		rl.DrawCubeWiresV({}, cube, rl.DARKGREEN)

		rl.EndMode3D()

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
