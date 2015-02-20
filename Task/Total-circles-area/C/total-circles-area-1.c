#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <stdbool.h>

typedef double Fp;
typedef struct { Fp x, y, r; } Circle;

Circle circles[] = {
    { 1.6417233788,  1.6121789534, 0.0848270516},
    {-1.4944608174,  1.2077959613, 1.1039549836},
    { 0.6110294452, -0.6907087527, 0.9089162485},
    { 0.3844862411,  0.2923344616, 0.2375743054},
    {-0.2495892950, -0.3832854473, 1.0845181219},
    { 1.7813504266,  1.6178237031, 0.8162655711},
    {-0.1985249206, -0.8343333301, 0.0538864941},
    {-1.7011985145, -0.1263820964, 0.4776976918},
    {-0.4319462812,  1.4104420482, 0.7886291537},
    { 0.2178372997, -0.9499557344, 0.0357871187},
    {-0.6294854565, -1.3078893852, 0.7653357688},
    { 1.7952608455,  0.6281269104, 0.2727652452},
    { 1.4168575317,  1.0683357171, 1.1016025378},
    { 1.4637371396,  0.9463877418, 1.1846214562},
    {-0.5263668798,  1.7315156631, 1.4428514068},
    {-1.2197352481,  0.9144146579, 1.0727263474},
    {-0.1389358881,  0.1092805780, 0.7350208828},
    { 1.5293954595,  0.0030278255, 1.2472867347},
    {-0.5258728625,  1.3782633069, 1.3495508831},
    {-0.1403562064,  0.2437382535, 1.3804956588},
    { 0.8055826339, -0.0482092025, 0.3327165165},
    {-0.6311979224,  0.7184578971, 0.2491045282},
    { 1.4685857879, -0.8347049536, 1.3670667538},
    {-0.6855727502,  1.6465021616, 1.0593087096},
    { 0.0152957411,  0.0638919221, 0.9771215985}};

const size_t n_circles = sizeof(circles) / sizeof(Circle);

static inline Fp min(const Fp a, const Fp b) { return a <= b ? a : b; }

static inline Fp max(const Fp a, const Fp b) { return a >= b ? a : b; }

static inline Fp sq(const Fp a) { return a * a; }

// Return an uniform random value in [a, b).
static inline double uniform(const double a, const double b) {
    const double r01 = rand() / (double)RAND_MAX;
    return a + (b - a) * r01;
}

static inline bool is_inside_circles(const Fp x, const Fp y) {
    for (size_t i = 0; i < n_circles; i++)
        if (sq(x - circles[i].x) + sq(y - circles[i].y) < circles[i].r)
            return true;
    return false;
}

int main() {
    // Initialize the bounding box (bbox) of the circles.
    Fp x_min = INFINITY, x_max = -INFINITY;
    Fp y_min = x_min, y_max = x_max;

    // Compute the bounding box of the circles.
    for (size_t i = 0; i < n_circles; i++) {
        Circle *c = &circles[i];
        x_min = min(x_min, c->x - c->r);
        x_max = max(x_max, c->x + c->r);
        y_min = min(y_min, c->y - c->r);
        y_max = max(y_max, c->y + c->r);

        c->r *= c->r; // Square the radii to speed up testing.
    }

    const Fp bbox_area = (x_max - x_min) * (y_max - y_min);

    // Montecarlo sampling.
    srand(time(0));
    size_t to_try = 1U << 16;
    size_t n_tries = 0;
    size_t n_hits = 0;

    while (true) {
        n_hits += is_inside_circles(uniform(x_min, x_max),
                                    uniform(y_min, y_max));
        n_tries++;

        if (n_tries == to_try) {
            const Fp area = bbox_area * n_hits / n_tries;
            const Fp r = (Fp)n_hits / n_tries;
            const Fp s = area * sqrt(r * (1 - r) / n_tries);
            printf("%.4f +/- %.4f (%zd samples)\n", area, s, n_tries);
            if (s * 3 <= 1e-3) // Stop at 3 sigmas.
                break;
            to_try *= 2;
        }
    }

    return 0;
}
