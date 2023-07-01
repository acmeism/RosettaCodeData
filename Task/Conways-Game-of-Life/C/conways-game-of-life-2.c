#include <FastLED.h>

#define LED_PIN     3
#define LED_TYPE    WS2812B
#define WIDTH       20
#define HEIGHT      15
#define NUM_LEDS    (WIDTH*HEIGHT)
#define BRIGHTNESS  100
#define COLOR_ORDER GRB
#define SERPENTINE  1
#define FRAMERATE   1
#define SCALE       1

CRGB leds[NUM_LEDS];

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define for_x for (int x = 0; x < w; x++)
#define for_y for (int y = 0; y < h; y++)
#define for_xy for_x for_y

const int w = WIDTH, h = HEIGHT;
unsigned univ[h][w];

int getLEDpos(int x, int y){ // for a serpentine raster
    return (y%2 || !SERPENTINE) ? y*WIDTH + x : y*WIDTH + (WIDTH - 1 - x);
}

void show(void *u, int w, int h)
{
    int (*univ)[w] = u;
    for_xy {
        leds[getLEDpos(x, y)] = univ[y][x] ? CRGB::White: CRGB::Black;
    }
    FastLED.show();
}

void evolve(void *u, int w, int h)
{
    unsigned (*univ)[w] = u;
    unsigned newU[h][w];

    for_y for_x {
        int n = 0;
        for (int y1 = y - 1; y1 <= y + 1; y1++)
            for (int x1 = x - 1; x1 <= x + 1; x1++)
                if (univ[(y1 + h) % h][(x1 + w) % w])
                    n++;

        if (univ[y][x]) n--;
        newU[y][x] = (n == 3 || (n == 2 && univ[y][x]));
    }
    for_y for_x univ[y][x] = newU[y][x];
}

void setup(){
    //Initialize leds after safety period
    FastLED.delay(500);
    FastLED.addLeds<LED_TYPE, LED_PIN, COLOR_ORDER>(leds, NUM_LEDS).setCorrection( TypicalLEDStrip );
    FastLED.setBrightness(  BRIGHTNESS );

    //Seed random with analog noise
    randomSeed(analogRead(0));

    for_xy univ[y][x] = random() %10 <= 1 ? 1 : 0;
}

void loop(){
    show(univ, w, h);
    evolve(univ, w, h);
    FastLED.delay(1000/FRAMERATE);
}
