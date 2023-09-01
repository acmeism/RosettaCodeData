// Standard C++ stuff
#include <iostream>
#include <array>
#include <cmath>
#include <numbers>

// SDL2 stuff
#include "SDL2/SDL.h"

// Compile: g++ -std=c++20 -Wall -Wextra -pedantic -Ofast SDL2Plasma.cpp -o SDL2Plasma -lSDL2 -fopenmp

struct RGB {
    int Red, Green, Blue;
};

RGB HSBToRGB(const float hue, const float saturation, const float brightness) {
    float Red   = 0,
          Green = 0,
          Blue  = 0;

    if (hue == 1) {
        Red = brightness;
    } else {
        float Sector = hue * 360,
              Cosine = std::cos(Sector*std::numbers::pi/180),
              Sine   = std::sin(Sector*std::numbers::pi/180);

        Red   = brightness * Cosine + saturation * Sine;
        Green = brightness * Cosine - saturation * Sine;
        Blue  = brightness - saturation * Cosine;
    }

    RGB Result;
    Result.Red   = (int)(Red * 255);
    Result.Green = (int)(Green * 255);
    Result.Blue  = (int)(Blue * 255);

    return Result;
}

template <int width_array_length, int height_array_length>
void CalculatePlasma(std::array<std::array<float, width_array_length>, height_array_length> &array) {
    #pragma omp parallel for
    for (unsigned long y = 0; y < array.size(); y++)
        #pragma omp simd
        for (unsigned long x = 0; x < array.at(0).size(); x++) {
            // Calculate the hue
            float Hue = std::sin(x/16.0);
            Hue += std::sin(y/8.0);
            Hue += std::sin((x+y)/16.0);
            Hue += std::sin(std::sqrt(x*x+y*y)/8.0);
            Hue += 4;
            // Clamp the hue to the range of [0, 1]
            Hue /= 8;
            array[y][x] = Hue;
        }
}

template <int width_array_length, int height_array_length>
void DrawPlasma(SDL_Renderer *r, SDL_Texture *t, const std::array<std::array<float, width_array_length>, height_array_length> &array, const float &hue_shift) {
    unsigned char *Bytes = NULL;
    int Pitch = 0;
    float Hue;

    // Lock the texture
    SDL_LockTexture(t, NULL, (void**)&Bytes, &Pitch);

    for (unsigned long y = 0; y < array.size(); y++)
        for (unsigned long x = 0; x < array.at(0).size(); x++) {
            // Convert the HSB value to RGB value
            Hue = hue_shift + std::fmod(array[y][x], 1);
            RGB CurrentColour = HSBToRGB(Hue, 1, 1);

            // Write colour data directly to texture
            Bytes[y*Pitch+x*4]   = CurrentColour.Red;   // Red
            Bytes[y*Pitch+x*4+1] = CurrentColour.Green; // Green
            Bytes[y*Pitch+x*4+2] = CurrentColour.Blue;  // Blue
            Bytes[y*Pitch+x*4+3] = 0xff;                // Alpha
        }

    // Unlock the texture
    SDL_UnlockTexture(t);

    // Feed the finished texture to the renderer
    SDL_RenderCopy(r, t, NULL, NULL);
}

int main() {
    const unsigned DefaultWidth  = 640,
                   DefaultHeight = 640;
    std::array<std::array<float, DefaultWidth>, DefaultHeight> ScreenArray;

    SDL_Window *Window = NULL;     // Define window
    SDL_Renderer *Renderer = NULL; // Define renderer

    // Init everything just for sure
    SDL_Init(SDL_INIT_EVERYTHING);

    // Set window size to 640x640, always shown
    Window = SDL_CreateWindow("Plasma effect", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, DefaultWidth, DefaultHeight, SDL_WINDOW_SHOWN);
    Renderer = SDL_CreateRenderer(Window, -1, SDL_RENDERER_ACCELERATED);
    SDL_Texture *PlasmaTexture = SDL_CreateTexture(Renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STREAMING, DefaultWidth, DefaultHeight);

    // Set background colour to white
    SDL_SetRenderDrawColor(Renderer, 0xff, 0xff, 0xff, 0xff);
    SDL_RenderClear(Renderer);

    // Create an event handler and a "quit" flag
    SDL_Event e;
    bool KillWindow = false;

    CalculatePlasma<DefaultWidth, DefaultHeight>(ScreenArray);
    float HueShift = 0.0;

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
        // Render the plasma
        DrawPlasma<DefaultWidth, DefaultHeight>(Renderer, PlasmaTexture, ScreenArray, HueShift);
        SDL_RenderPresent(Renderer);

        if (HueShift < 1) {
            HueShift = std::fmod(HueShift + 0.0025, 3);
        } else {
            CalculatePlasma<DefaultWidth, DefaultHeight>(ScreenArray);
            HueShift = 0.0;
        }
    }

    // Destroy renderer and window
    SDL_DestroyRenderer(Renderer);
    SDL_DestroyWindow(Window);
    SDL_Quit();

    return 0;
}
