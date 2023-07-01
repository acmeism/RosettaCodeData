// See https://en.wikipedia.org/wiki/Sierpi%C5%84ski_curve#Arrowhead_curve
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

// Structure to keep track of current position and orientation
typedef struct cursor_tag {
    double x;
    double y;
    int angle;
} cursor_t;

void turn(cursor_t* cursor, int angle) {
    cursor->angle = (cursor->angle + angle) % 360;
}

void draw_line(FILE* out, cursor_t* cursor, double length) {
    double theta = (M_PI * cursor->angle)/180.0;
    cursor->x += length * cos(theta);
    cursor->y += length * sin(theta);
    fprintf(out, "L%g,%g\n", cursor->x, cursor->y);
}

void curve(FILE* out, int order, double length, cursor_t* cursor, int angle) {
    if (order == 0) {
        draw_line(out, cursor, length);
    } else {
        curve(out, order - 1, length/2, cursor, -angle);
        turn(cursor, angle);
        curve(out, order - 1, length/2, cursor, angle);
        turn(cursor, angle);
        curve(out, order - 1, length/2, cursor, -angle);
    }
}

void write_sierpinski_arrowhead(FILE* out, int size, int order) {
    const double margin = 20.0;
    const double side = size - 2.0 * margin;
    cursor_t cursor;
    cursor.angle = 0;
    cursor.x = margin;
    cursor.y = 0.5 * size + 0.25 * sqrt(3) * side;
    if ((order & 1) != 0)
        turn(&cursor, -60);
    fprintf(out, "<svg xmlns='http://www.w3.org/2000/svg' width='%d' height='%d'>\n",
            size, size);
    fprintf(out, "<rect width='100%%' height='100%%' fill='white'/>\n");
    fprintf(out, "<path stroke-width='1' stroke='black' fill='none' d='");
    fprintf(out, "M%g,%g\n", cursor.x, cursor.y);
    curve(out, order, side, &cursor, 60);
    fprintf(out, "'/>\n</svg>\n");
}

int main(int argc, char** argv) {
    const char* filename = "sierpinski_arrowhead.svg";
    if (argc == 2)
        filename = argv[1];
    FILE* out = fopen(filename, "w");
    if (!out) {
        perror(filename);
        return EXIT_FAILURE;
    }
    write_sierpinski_arrowhead(out, 600, 8);
    fclose(out);
    return EXIT_SUCCESS;
}
