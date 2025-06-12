#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <stdint.h>

#define PI 3.14159265358979323846f

typedef struct Vector2 {
    float x, y;
} Vector2;

// https://github.com/raysan5/raylib/blob/5aa3f0ccc374c1fbfc880402b37871b9c3bb7d8e/src/raymath.h#L316
float vecdist(Vector2 v1, Vector2 v2) { return sqrtf((v1.x - v2.x) * (v1.x - v2.x) + (v1.y - v2.y) * (v1.y - v2.y)); }

// Packed because othervise compiler padd it with a zero.
// This breaks ppm format as it expects 3 bytes per pixel.
// Alternatively, if your compiler doesn't support __attribute__ you can remove it but
// then you will have to write every byte separately
typedef struct __attribute__((__packed__)) Color {
    unsigned char r, g, b;
} Color;

// Copied from
// https://github.com/raysan5/raylib/blob/5aa3f0ccc374c1fbfc880402b37871b9c3bb7d8e/src/rtextures.c#L4936
// Hue is provided in degrees: [0..360]
// Saturation/Value are provided normalized: [0.0f..1.0f]
Color from_hsv(float hue, float saturation, float value) {
    Color color = {0, 0, 0};

    // Red channel
    float k = fmodf((5.0f + hue / 60.0f), 6);
    float t = 4.0f - k;
    k       = (t < k) ? t : k;
    k       = (k < 1) ? k : 1;
    k       = (k > 0) ? k : 0;
    color.r = (unsigned char)((value - value * saturation * k) * 255.0f);

    // Green channel
    k       = fmodf((3.0f + hue / 60.0f), 6);
    t       = 4.0f - k;
    k       = (t < k) ? t : k;
    k       = (k < 1) ? k : 1;
    k       = (k > 0) ? k : 0;
    color.g = (unsigned char)((value - value * saturation * k) * 255.0f);

    // Blue channel
    k       = fmodf((1.0f + hue / 60.0f), 6);
    t       = 4.0f - k;
    k       = (t < k) ? t : k;
    k       = (k < 1) ? k : 1;
    k       = (k > 0) ? k : 0;
    color.b = (unsigned char)((value - value * saturation * k) * 255.0f);

    return color;
}

int main(void) {
    size_t img_size = 1000;
    FILE *f         = fopen("HSVWheel.ppm", "wb");
    if (!f) exit(69);

    // ppm header:
    // "P6" - magic number that identifies format as binary with color, line break, space separated tuple with width and height of
    // image in ASCII, line break, max value per color channel in ASCII, line break.
    fprintf(f, "P6\n%lld %lld\n255\n", img_size, img_size);

    const size_t radius  = img_size / 2;
    const Vector2 center = {radius, radius};

    // iterate over every pixel of image
    for (size_t y = 0; y < img_size; ++y) {
        for (size_t x = 0; x < img_size; ++x) {
            // if distance from pixel to center of image - we inside of the colorwheel
            float dist = vecdist(center, (Vector2){x, y});
            if (dist <= radius) {
                // angle between x-axis and line from center to pixel in radians
                // add PI/2 to rotate the hue by 90 degrees and have red on top
                float angle = atan2f(y - center.y, x - center.x) + (PI / 2);
                // normalize angle to be in range [0..2π]
                if (angle < 0) angle += 2 * PI;
                // convert from radian to degree
                float hue = angle * (180 / PI);
                // normalize distance to [0..1] range and use as saturation
                float sat   = dist / radius;
                Color color = from_hsv(hue, sat, 1);
                fwrite(&color, sizeof(Color), 1, f);
            } else {
                // Fill rest with background color
                Color color = {0x1e, 0x1e, 0x1e};
                fwrite(&color, sizeof(Color), 1, f);
            }
        }
    }

    // cleanup
    fflush(f);
    fclose(f);
    return 0;
}
