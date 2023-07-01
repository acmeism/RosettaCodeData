#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <FreeImage.h>

#define NUM_PARTICLES  1000
#define SIZE           800

void draw_brownian_tree(int world[SIZE][SIZE]){
  int px, py; // particle values
  int dx, dy; // offsets
  int i;

  // set the seed
  world[rand() % SIZE][rand() % SIZE] = 1;

  for (i = 0; i < NUM_PARTICLES; i++){
    // set particle's initial position
    px = rand() % SIZE;
    py = rand() % SIZE;

    while (1){
      // randomly choose a direction
      dx = rand() % 3 - 1;
      dy = rand() % 3 - 1;

      if (dx + px < 0 || dx + px >= SIZE || dy + py < 0 || dy + py >= SIZE){
        // plop the particle into some other random location
        px = rand() % SIZE;
        py = rand() % SIZE;
      }else if (world[py + dy][px + dx] != 0){
        // bumped into something
        world[py][px] = 1;
        break;
      }else{
        py += dy;
        px += dx;
      }
    }
  }
}

int main(){
  int world[SIZE][SIZE];
  FIBITMAP * img;
  RGBQUAD rgb;
  int x, y;

  memset(world, 0, sizeof world);
  srand((unsigned)time(NULL));

  draw_brownian_tree(world);

  img = FreeImage_Allocate(SIZE, SIZE, 32, 0, 0, 0);

  for (y = 0; y < SIZE; y++){
    for (x = 0; x < SIZE; x++){
      rgb.rgbRed = rgb.rgbGreen = rgb.rgbBlue = (world[y][x] ? 255 : 0);
      FreeImage_SetPixelColor(img, x, y, &rgb);
    }
  }
  FreeImage_Save(FIF_BMP, img, "brownian_tree.bmp", 0);
  FreeImage_Unload(img);
}
