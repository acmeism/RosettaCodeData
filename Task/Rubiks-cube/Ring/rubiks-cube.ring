load "raylib.ring"

screenWidth  = 800
screenHeight = 600
InitWindow(screenWidth, screenHeight, "Rubik's cube")

camera = new Camera3D
camera.position   = new Vector3(9.0, 9.0, 11.0)
camera.target     = new Vector3(0.0, 0.0, 0.0)
camera.up         = new Vector3(0.0, 1.0, 0.0)
camera.fovy       = 40.0
camera.projection = CAMERA_PERSPECTIVE
SetTargetFPS(60)

while !WindowShouldClose()

    BeginDrawing()
    ClearBackground(RAYWHITE)

    BeginMode3D(camera)

        for x = -1 to 1
            for y = -1 to 1
                for z = -1 to 1

                    posX = x * 2.1
                    posY = y * 2.1
                    posZ = z * 2.1

                    cubePos = new Vector3(posX, posY, posZ)
                    DrawCube(cubePos, 1.9, 1.9, 1.9, BLACK)

                    if y = 1
                        topFace = new Vector3(posX, posY + 0.95, posZ)
                        DrawCube(topFace, 1.8, 0.05, 1.8, WHITE)
                    ok

                    if y = -1
                        bottomFace = new Vector3(posX, posY - 0.95, posZ)
                        DrawCube(bottomFace, 1.8, 0.05, 1.8, YELLOW)
                    ok

                    if z = 1
                        frontFace = new Vector3(posX, posY, posZ + 0.95)
                        DrawCube(frontFace, 1.8, 1.8, 0.05, GREEN)
                    ok

                    if z = -1
                        backFace = new Vector3(posX, posY, posZ - 0.95)
                        DrawCube(backFace, 1.8, 1.8, 0.05, BLUE)
                    ok

                    if x = 1
                        rightFace = new Vector3(posX + 0.95, posY, posZ)
                        DrawCube(rightFace, 0.05, 1.8, 1.8, RED)
                    ok

                    if x = -1
                        leftFace = new Vector3(posX - 0.95, posY, posZ)
                        DrawCube(leftFace, 0.05, 1.8, 1.8, ORANGE)
                    ok

                    DrawCubeWires(cubePos, 1.95, 1.95, 1.95, BLACK)

                next
            next
        next

    EndMode3D()

    DrawText("Standard 3x3 Rubik's Cube", 15, 15, 20, DARKGRAY)
    DrawText("Scheme: White(Top) | Green(Front) | Red(Right)", 15, 40, 16, GRAY)

    EndDrawing()
end

CloseWindow()
