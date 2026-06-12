#include <SFML/Graphics.h>

#include <stdlib.h>
#include <string.h>

#include <math.h>

const double tau = 6.283185307; /* circle constant */
const double phi = 1.618033989; /* 0.5 × (1 + sqrt(5)) */

const int scale = 600;
const int seeds = 5 * scale;

int
main(void)
{
	sfVideoMode mode = {scale, scale, 32};
	sfRenderWindow* window;
	sfEvent event;
	sfVideoMode vidmode;
	sfVector2i winpos;
	sfCircleShape **circles;
	int i;
	float r, t;
	sfVector2f pos;

	circles = malloc(seeds * sizeof(sfCircleShape*));

	/* Create the main window */
	window = sfRenderWindow_create(mode, "Sunflower", sfClose, NULL);
	if (!window)
		return EXIT_FAILURE;

	/* Centre the window */
	vidmode = sfVideoMode_getDesktopMode();
	winpos.x = vidmode.width/2 - scale/2;
	winpos.y = vidmode.height/2 - scale/2;
	sfRenderWindow_setPosition(window, winpos);

	/* Generate the circles */
	for (i=0; i<seeds; i++) {
		r = 2.0 * pow(i, phi) / seeds;
		t = tau * phi * i;
		pos.x = r * sin(t) + scale/2;
		pos.y = r * cos(t) + scale/2;

		circles[i] = sfCircleShape_create();
		sfCircleShape_setPosition(circles[i], pos);
		sfCircleShape_setRadius(circles[i], sqrt(i)/13.0);
		sfCircleShape_setFillColor(circles[i], sfTransparent);
		sfCircleShape_setOutlineColor(circles[i], sfColor_fromRGB(255,215,0));
		sfCircleShape_setOutlineThickness(circles[i], 1.0);
	}

	/* Start the event loop */
	while (sfRenderWindow_isOpen(window)) {
		/* Process events */
		while (sfRenderWindow_pollEvent(window, &event)) {
			/* Close window : exit */
			if (event.type == sfEvtClosed)
				sfRenderWindow_close(window);
		}

		sfRenderWindow_clear(window, sfBlack);
		for (i=0; i<seeds; i++)
			sfRenderWindow_drawCircleShape(window, circles[i], NULL);
		sfRenderWindow_display(window);
	}
	sfRenderWindow_destroy(window);

	return EXIT_SUCCESS;
}
