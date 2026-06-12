#include <SFML/Graphics.h>

#include <stdlib.h>
#include <math.h>

#define WIDTH 1280
#define HEIGHT 1024
#define NUM_RECTS 64

sfColor
HSVtoRGB(double h, double s, double v)
{
	double hp = h / 60.0;
	double c = s * v;
	double x = c * (1 - fabs(fmod(hp, 2) - 1));
	double m = v - c;
	double r = 0, g = 0, b = 0;
	if (hp <= 1) {
		r = c;
		g = x;
	}
	else if (hp <= 2) {
		r = x;
		g = c;
	}
	else if (hp <= 3) {
		g = c;
		b = x;
	}
	else if (hp <= 4) {
		g = x;
		b = c;
	}
	else if (hp <= 5) {
		r = x;
		b = c;
	}
	else {
		r = c;
		b = x;
	}
	r += m;
	g += m;
	b += m;
	return sfColor_fromRGB(r * 255, g * 255, b * 255);
}

int
main(void)
{
	sfVideoMode mode = {WIDTH, HEIGHT, 32};
	sfRenderWindow* window;
	sfEvent event;
	sfVideoMode vidmode;
	sfVector2i winpos;
	sfRectangleShape *rects[NUM_RECTS];
	int i;
	float a, h;
	sfVector2f vec;
	sfColor colour;
	sfClock *clock;
	sfTime elapsed;

	/* Create the main window */
	window = sfRenderWindow_create(mode, "Vibrating Rectangles", sfClose, NULL);
	if (!window)
		return EXIT_FAILURE;

	/* Centre the window */
	vidmode = sfVideoMode_getDesktopMode();
	winpos.x = vidmode.width/2 - WIDTH/2;
	winpos.y = vidmode.height/2 - HEIGHT/2;
	sfRenderWindow_setPosition(window, winpos);

	/* Generate the rectangles */
	for (i=0; i<NUM_RECTS; i++) {
		rects[i] = sfRectangleShape_create();
		vec.x = 10*i;
		vec.y = 8*i;
		sfRectangleShape_setPosition(rects[i], vec);
		vec.x = WIDTH - 2*vec.x;
		vec.y = HEIGHT - 2*vec.y;
		sfRectangleShape_setSize(rects[i], vec);
		a = 360.0*i / NUM_RECTS;
		colour = HSVtoRGB(a, 1.0, 1.0);
		sfRectangleShape_setFillColor(rects[i], sfTransparent);
		sfRectangleShape_setOutlineColor(rects[i], colour);
		sfRectangleShape_setOutlineThickness(rects[i], 4.0);
	}

	/* Start the event loop */
	h = 0;
	clock = sfClock_create();
	while (sfRenderWindow_isOpen(window)) {
		/* Process events */
		while (sfRenderWindow_pollEvent(window, &event)) {
			/* Close window : exit */
			if (event.type == sfEvtClosed)
				sfRenderWindow_close(window);
		}

		elapsed = sfClock_restart(clock);
		h += elapsed.microseconds / 10000.0;
		if (h > 360.0)
			h -= 360.0;

		sfRenderWindow_clear(window, sfBlack);
		for (i=0; i<NUM_RECTS; i++)
		{
			a = (float)h + 360.0*i / NUM_RECTS;
			if (a > 360.0)
				a -= 360.0;
			colour = HSVtoRGB(a, 1.0, 1.0);
			sfRectangleShape_setOutlineColor(rects[i], colour);
			sfRenderWindow_drawRectangleShape(window, rects[i], NULL);
		}
		sfRenderWindow_display(window);
	}
	sfRenderWindow_destroy(window);

	return EXIT_SUCCESS;
}
