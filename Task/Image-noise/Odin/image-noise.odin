package main

import rl "vendor:raylib"

main :: proc() {
   rl.InitWindow(320, 240, "Rosetta Code - Image noise")

   for !rl.WindowShouldClose() {
      img := rl.GenImageWhiteNoise(320, 240, .25)

      tex := rl.LoadTextureFromImage(img)

      rl.UnloadImage(img)

      rl.BeginDrawing()

      rl.DrawTextureV(tex, {}, rl.WHITE)
      rl.DrawFPS(4, 4)

      rl.EndDrawing()

      rl.UnloadTexture(tex)
   }

   rl.CloseWindow()
}
