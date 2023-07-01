#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <SDL/SDL.h>

unsigned int frames = 0;
unsigned int t_acc = 0;

void print_fps ()
{
  static Uint32 last_t = 0;
  Uint32 t = SDL_GetTicks();
  Uint32 dt = t - last_t;
  t_acc += dt;
  if (t_acc > 1000)
  {
    unsigned int el_time = t_acc / 1000;
    printf("- fps: %g\n",
            (float) frames / (float) el_time);
    t_acc = 0;
    frames = 0;
  }
  last_t = t;
}

void blit_noise(SDL_Surface *surf)
{
  unsigned int i;
  long dim = surf->w * surf->h;
  while (1)
  {
    SDL_LockSurface(surf);
    for (i=0; i < dim; ++i) {
      ((unsigned char *)surf->pixels)[i] = ((rand() & 1) ? 255 : 0);
    }
    SDL_UnlockSurface(surf);
    SDL_Flip(surf);
    ++frames;
    print_fps();
  }
}

int main(void)
{
  SDL_Surface *surf = NULL;
  srand((unsigned int)time(NULL));
  SDL_Init(SDL_INIT_TIMER | SDL_INIT_VIDEO);
  surf = SDL_SetVideoMode(320, 240, 8, SDL_DOUBLEBUF | SDL_HWSURFACE);
  blit_noise(surf);
}
