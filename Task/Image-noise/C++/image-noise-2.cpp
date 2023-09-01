// Standard C++ stuff
#include <iostream>
#include <string>
#include <random>

// SDL2 stuff
#include "SDL2/SDL.h"

// Other crazy stuffs
#define SCREEN_WIDTH  320
#define SCREEN_HEIGHT 240
#define COLOUR_BLACK  0,    0,    0,    0xff
#define COLOUR_WHITE  0xff, 0xff, 0xff, 0xff

// Compile: g++ -std=c++20 -Wall -Wextra -pedantic ImageNoise.cpp -o ImageNoise -lSDL2

template <class RandomGenerator>
void BlitNoise(SDL_Renderer *r, int width, int height, auto &dist, RandomGenerator &generator) {
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            // Use the random number generator in C++ Standard Library to determine draw colour
            if (dist(generator) == 0)
                // Set colour to black
                SDL_SetRenderDrawColor(r, COLOUR_BLACK);
            else if (dist(generator) == 1)
                // Set colour to white
                SDL_SetRenderDrawColor(r, COLOUR_WHITE);
            // Go through every scanline, and put pixels
            SDL_RenderDrawPoint(r, x, y);
        }
    }
}

void UpdateFPS(unsigned &frame_count, unsigned &timer, SDL_Window *window) {
    static Uint64 LastTime = 0;
    std::string NewWindowTitle;
    Uint64 Time = SDL_GetTicks(),
           Delta = Time - LastTime;
    timer += Delta;
    if (timer > 1000) {
        unsigned ElapsedTime = timer / 1000;
        NewWindowTitle = "Image noise - " + std::to_string((int)((float)frame_count/(float)ElapsedTime)) + " FPS"; // Dirty string trick
        SDL_SetWindowTitle(window, const_cast<char*>(NewWindowTitle.c_str()));
        timer = 0;
        frame_count = 0;
        NewWindowTitle.clear();
    }
    LastTime = Time;
}

int main() {
    std::random_device Device; // Random number device
    std::mt19937_64 Generator(Device()); // Random number generator
    std::uniform_int_distribution ColourState(0, 1); // Colour state
    unsigned Frames = 0,
             Timer = 0;

    SDL_Window *Window = NULL; // Define window
    SDL_Renderer *Renderer = NULL; // Define renderer

    // Init everything just for sure
    SDL_Init(SDL_INIT_EVERYTHING);

    // Set window size to 320x240, always shown
    Window = SDL_CreateWindow("Image noise - ?? FPS", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
    Renderer = SDL_CreateRenderer(Window, -1, SDL_RENDERER_ACCELERATED);

    // Set background colour to white
    SDL_SetRenderDrawColor(Renderer, COLOUR_WHITE);
    SDL_RenderClear(Renderer);

    // Create an event handler and a "quit" flag
    SDL_Event e;
    bool KillWindow = false;

    // The window runs until the "quit" flag is set to true
    while (!KillWindow) {
        while (SDL_PollEvent(&e) != 0) {
            // Go through the events in the queue
            switch (e.type) {
                // Event: user hits a key
                case SDL_QUIT: case SDL_KEYDOWN:
                    // Destroy window
                    KillWindow = true;
                    break;
            }
        }
        // Render the noise
        BlitNoise(Renderer, SCREEN_WIDTH, SCREEN_HEIGHT, ColourState, Generator);
        SDL_RenderPresent(Renderer);
        // Increment the "Frames" variable.
        // Then show the FPS count in the window title.
        ++Frames;
        UpdateFPS(Frames, Timer, Window);
    }

    // Destroy renderer and window
    SDL_DestroyRenderer(Renderer);
    SDL_DestroyWindow(Window);
    SDL_Quit();

    return 0;
}
