/************************************************************
 *                     JULIA SET  IN C++                    *
 *                    Library used:  SDL2                   *
 * Written by Katsumi -- https://twitter.com/realKatsumi_vn *
 ************************************************************/

// Standard C++ stuff
#include <iostream>
#include <complex>
#include <vector>
#include <array>

// SDL2 stuff
#include "SDL2/SDL.h"

// Other crazy stuffs
#define ScreenWidth  800
#define ScreenHeight 600

// Compile: g++ -std=c++20 -Wall -Wextra -pedantic julia-set-sdl2.cpp -o julia-set-sdl2 -lSDL2
// Yes, I use the British spelling, it's "colour" not "color". Deal with it.

void DrawJuliaSet(SDL_Renderer *r, int width, int height, double real, double imag, int maxiter) {
    // Generate colours
    std::vector<std::array<int, 3>> colours;
    for (int col = 0; col < 256; col++) {
        std::array<int, 3> CurrentColour = {(col >> 5) * 36, (col >> 3 & 7) * 36, (col & 3) * 85};
        colours.push_back(CurrentColour);
    }

    std::complex<double> c = {real, imag}, z;

    // Actual calculations
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            z.real(1.5 * (x - width / 2) / (0.5 * width));
            z.imag((y - height / 2) / (0.5 * height));

            int i = maxiter;

            while (std::norm(z) < 4 && i > 0) {
                z = z * z + c;
                i--;
            }

            // Draw the set on the window, pixel by pixel
            SDL_SetRenderDrawColor(r, colours[i][0], colours[i][1], colours[i][2], 0xff);
            SDL_RenderDrawPoint(r, x, y);
        }
    }
}

int main(int argc, char *args[]) {
    const int MaximumIterations = 256;

    SDL_Window *window = NULL; // Define window
    SDL_Renderer *renderer = NULL; // Define renderer

    // First things first: initialise video
    SDL_Init(SDL_INIT_EVERYTHING);

    window = SDL_CreateWindow( // Create window
        "Julia set - Press any key to exit",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        ScreenWidth, ScreenHeight, // Width and height
        SDL_WINDOW_SHOWN // Always show the window
    );

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED); // Create renderer

    SDL_SetRenderDrawColor(renderer, 0xff, 0xff, 0xff, 0xff);
    SDL_RenderClear(renderer); // Clear screen

    DrawJuliaSet(renderer, ScreenWidth, ScreenHeight, -0.7, 0.27015, MaximumIterations); // Draw the Julia set
    SDL_RenderPresent(renderer); // Render it!

    // Create an event handler and a "quit" flag
    SDL_Event e;
    bool KillWindow = false;

    while (!KillWindow) { // The window runs until the "quit" flag is set to true
        while (SDL_PollEvent(&e) != 0) {
            switch (e.type) { // Go through the events in the queue
                case SDL_QUIT: case SDL_KEYDOWN: // Event: user hits a key
                    // Destroy window
                    KillWindow = true;
                    break;
            }
        }
    }

    SDL_DestroyRenderer(renderer); // Destroy renderer
    SDL_DestroyWindow(window); // Destroy window
    SDL_Quit();

    return 0;
}
