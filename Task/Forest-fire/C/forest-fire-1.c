#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <pthread.h>

#include <SDL.h>

// defaults
#define PROB_TREE 0.55
#define PROB_F 0.00001
#define PROB_P 0.001

#define TIMERFREQ 100

#ifndef WIDTH
#  define WIDTH 640
#endif
#ifndef HEIGHT
#  define HEIGHT 480
#endif
#ifndef BPP
#  define BPP 32
#endif

#if BPP != 32
  #warning This program could not work with BPP different from 32
#endif

uint8_t *field[2], swapu;
double prob_f = PROB_F, prob_p = PROB_P, prob_tree = PROB_TREE;

enum cell_state {
  VOID, TREE, BURNING
};

// simplistic random func to give [0, 1)
double prand()
{
  return (double)rand() / (RAND_MAX + 1.0);
}

// initialize the field
void init_field(void)
{
  int i, j;
  swapu = 0;
  for(i = 0; i < WIDTH; i++)
  {
    for(j = 0; j < HEIGHT; j++)
    {
      *(field[0] + j*WIDTH + i) = prand() > prob_tree ? VOID : TREE;
    }
  }
}

// the "core" of the task: the "forest-fire CA"
bool burning_neighbor(int, int);
pthread_mutex_t synclock = PTHREAD_MUTEX_INITIALIZER;
static uint32_t simulate(uint32_t iv, void *p)
{
  int i, j;

  /*
    Since this is called by SDL, "likely"(*) in a separated
    thread, we try to avoid corrupted updating of the display
    (done by the show() func): show needs the "right" swapu
    i.e. the right complete field. (*) what if it is not so?
    The following is an attempt to avoid unpleasant updates.
   */
  pthread_mutex_lock(&synclock);

  for(i = 0; i < WIDTH; i++) {
    for(j = 0; j < HEIGHT; j++) {
      enum cell_state s = *(field[swapu] + j*WIDTH + i);
      switch(s)
      {
      case BURNING:
	*(field[swapu^1] + j*WIDTH + i) = VOID;
	break;
      case VOID:
	*(field[swapu^1] + j*WIDTH + i) = prand() > prob_p ? VOID : TREE;
	break;
      case TREE:
	if (burning_neighbor(i, j))
	  *(field[swapu^1] + j*WIDTH + i) = BURNING;
	else
	  *(field[swapu^1] + j*WIDTH + i) = prand() > prob_f ? TREE : BURNING;
	break;
      default:
	fprintf(stderr, "corrupted field\n");
	break;
      }
    }
  }
  swapu ^= 1;
  pthread_mutex_unlock(&synclock);
  return iv;
}

// the field is a "part" of an infinite "void" region
#define NB(I,J) (((I)<WIDTH)&&((I)>=0)&&((J)<HEIGHT)&&((J)>=0) \
		 ? (*(field[swapu] + (J)*WIDTH + (I)) == BURNING) : false)
bool burning_neighbor(int i, int j)
{
  return NB(i-1,j-1) || NB(i-1, j) || NB(i-1, j+1) ||
    NB(i, j-1) || NB(i, j+1) ||
    NB(i+1, j-1) || NB(i+1, j) || NB(i+1, j+1);
}


// "map" the field into gfx mem
// burning trees are red
// trees are green
// "voids" are black;
void show(SDL_Surface *s)
{
  int i, j;
  uint8_t *pixels = (uint8_t *)s->pixels;
  uint32_t color;
  SDL_PixelFormat *f = s->format;

  pthread_mutex_lock(&synclock);
  for(i = 0; i < WIDTH; i++) {
    for(j = 0; j < HEIGHT; j++) {
      switch(*(field[swapu] + j*WIDTH + i)) {
      case VOID:
	color = SDL_MapRGBA(f, 0,0,0,255);
	break;
      case TREE:
	color = SDL_MapRGBA(f, 0,255,0,255);
	break;
      case BURNING:
	color = SDL_MapRGBA(f, 255,0,0,255);
	break;
      }
      *(uint32_t*)(pixels + j*s->pitch + i*(BPP>>3)) = color;
    }
  }
  pthread_mutex_unlock(&synclock);
}

int main(int argc, char **argv)
{
  SDL_Surface *scr = NULL;
  SDL_Event event[1];
  bool quit = false, running = false;
  SDL_TimerID tid;

  // add variability to the simulation
  srand(time(NULL));

  // we can change prob_f and prob_p
  // prob_f prob of spontaneous ignition
  // prob_p prob of birth of a tree
  double *p;
  for(argv++, argc--; argc > 0; argc--, argv++)
  {
    if ( strcmp(*argv, "prob_f") == 0 && argc > 1 )
    {
      p = &prob_f;
    } else if ( strcmp(*argv, "prob_p") == 0 && argc > 1 ) {
      p = &prob_p;
    } else if ( strcmp(*argv, "prob_tree") == 0 && argc > 1 ) {
      p = &prob_tree;
    } else  continue;


    argv++; argc--;
    char *s = NULL;
    double t = strtod(*argv, &s);
    if (s != *argv) *p = t;
  }

  printf("prob_f %lf\nprob_p %lf\nratio %lf\nprob_tree %lf\n",
	 prob_f, prob_p, prob_p/prob_f,
	 prob_tree);

  if ( SDL_Init(SDL_INIT_VIDEO|SDL_INIT_TIMER) != 0 ) return EXIT_FAILURE;
  atexit(SDL_Quit);

  field[0] = malloc(WIDTH*HEIGHT);
  if (field[0] == NULL) exit(EXIT_FAILURE);
  field[1] = malloc(WIDTH*HEIGHT);
  if (field[1] == NULL) { free(field[0]); exit(EXIT_FAILURE); }

  scr = SDL_SetVideoMode(WIDTH, HEIGHT, BPP, SDL_HWSURFACE|SDL_DOUBLEBUF);
  if (scr == NULL) {
    fprintf(stderr, "SDL_SetVideoMode: %s\n", SDL_GetError());
    free(field[0]); free(field[1]);
    exit(EXIT_FAILURE);
  }

  init_field();

  tid = SDL_AddTimer(TIMERFREQ, simulate, NULL); // suppose success
  running = true;

  event->type = SDL_VIDEOEXPOSE;
  SDL_PushEvent(event);

  while(SDL_WaitEvent(event) && !quit)
  {
    switch(event->type)
    {
    case SDL_VIDEOEXPOSE:
      while(SDL_LockSurface(scr) != 0) SDL_Delay(1);
      show(scr);
      SDL_UnlockSurface(scr);
      SDL_Flip(scr);
      event->type = SDL_VIDEOEXPOSE;
      SDL_PushEvent(event);
      break;
    case SDL_KEYDOWN:
      switch(event->key.keysym.sym)
      {
      case SDLK_q:
	quit = true;
	break;
      case SDLK_p:
	if (running)
	{
	  running = false;
	  pthread_mutex_lock(&synclock);
	  SDL_RemoveTimer(tid); // ignore failure...
	  pthread_mutex_unlock(&synclock);
	} else {
	  running = true;
	  tid = SDL_AddTimer(TIMERFREQ, simulate, NULL);
	  // suppose success...
	}
	break;
      }
    case SDL_QUIT:
      quit = true;
      break;
    }
  }

  if (running) {
    pthread_mutex_lock(&synclock);
    SDL_RemoveTimer(tid);
    pthread_mutex_unlock(&synclock);
  }
  free(field[0]); free(field[1]);
  exit(EXIT_SUCCESS);
}
