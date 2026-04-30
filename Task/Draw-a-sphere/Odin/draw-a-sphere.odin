package sphere

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(640, 480, "Rosetta Code - draw a sphere")

	camera: rl.Camera3D
	camera.fovy = 45
	camera.position = {0, 2.5, 5}
	camera.up = {0, 1, 0}

	for !rl.WindowShouldClose() {
		rl.UpdateCamera(&camera, .ORBITAL)
		
		rl.BeginDrawing()

		rl.ClearBackground(rl.RAYWHITE)

		rl.BeginMode3D(camera)

		rl.DrawGrid(10, .5)

		rl.DrawSphere({}, .5, rl.LIME)

		rl.EndMode3D()

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
