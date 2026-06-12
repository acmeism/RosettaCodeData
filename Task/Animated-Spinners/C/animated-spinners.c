#include <raylib.h>
#include <raymath.h>

#include <stdio.h>

#define WINDOW_SIZE    800
#define WINDOW_RADIUS  WINDOW_SIZE / 2

#define SPINNER_RADIUS 100
#define SPINNER_OFFSET SPINNER_RADIUS * 1.5

// Structure to represent a spinner
typedef struct Spinner {
    Vector2 pos;
    float angle;
    Color color;
} Spinner;

// Calculate the end point of the spinner line
Vector2 end_pos(Vector2 pos, float angle) {
    Vector2 p = {
        pos.x + SPINNER_RADIUS * cosf(DEG2RAD * angle),
        pos.y + SPINNER_RADIUS * sinf(DEG2RAD * angle)
    };
    return p;
}

int main(int argc, char const *argv[]) {
    // Default rotation speed
    float speed = 5;
    // Allow overriding speed via command line argument
    if (argc > 1) {
        float _speed = atof(argv[1]); // Convert argument to float
        // Use the provided speed if it's a valid number
        if (isnormal(_speed)) speed = _speed;
    }

    SetConfigFlags(FLAG_MSAA_4X_HINT);
    InitWindow(WINDOW_SIZE, WINDOW_SIZE, "Spinnnn");

    const Vector2 center = {WINDOW_SIZE / 2, WINDOW_SIZE / 2};
    Spinner spinners[5]  = {
        {center,                                                 50, GREEN },
        {{center.x - SPINNER_OFFSET, center.y + SPINNER_OFFSET}, 50, RED   },
        {{center.x + SPINNER_OFFSET, center.y + SPINNER_OFFSET}, 50, WHITE },
        {{center.x - SPINNER_OFFSET, center.y - SPINNER_OFFSET}, 50, YELLOW},
        {{center.x + SPINNER_OFFSET, center.y - SPINNER_OFFSET}, 50, ORANGE}
    };

    // Main loop
    while (!WindowShouldClose()) {
        // Use deltatime to keep speed consistent regardless of framerate
        float dt         = GetFrameTime();
        Vector2 mouse    = GetMousePosition();
        Vector2 m_offset = {0};
        // If the mouse is within the window radius, calculate it's offset relative to the
        // center
        if (Vector2Distance(mouse, center) < WINDOW_RADIUS)
            m_offset = Vector2Scale(Vector2Subtract(mouse, center), 0.1);

        BeginDrawing();
        {
            ClearBackground(DARKGRAY);
            DrawCircle(WINDOW_RADIUS, WINDOW_RADIUS, WINDOW_RADIUS, BLACK);
            for (int i = 0; i < 5; i++) {
                Spinner *s  = &spinners[i]; // Get a pointer to the current spinner
                Vector2 pos = Vector2Add(s->pos, m_offset); // Apply offset
                DrawLineEx(pos, end_pos(pos, s->angle), 2, s->color);
                s->angle += dt * 100 * speed;
                if (s->angle > 360) s->angle = 0;
            }
        }
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
