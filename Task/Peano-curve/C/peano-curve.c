#include <SFML/Graphics.h>

#include <stdlib.h>
#include <string.h>

/* should be a power of 3 e.g. 1, 3, 9, 27, 81, 243, 729 */
const int peano_width = 81;

/* the window is a square */
const int window_side_len = 800;

void
peano(sfVertexArray *verts, int x, int y, int lg, int i1, int i2)
{
	/* initial x, initial y, curve width (3^m), initial i1, initial i2 */
	if (lg == 1) {
		sfVertex v;
		v.position.x = 12.0 * x; /* multiply by 12 to scale-up the curve */
		v.position.y = 12.0 * y;
		v.color = sfWhite;
		sfVertexArray_append(verts, v);
		return;
	}
	lg = lg/3;

	peano(verts, x+(2*i1*lg),		y+(2*i1*lg),		lg,   i1,	  i2);
	peano(verts, x+((i1-i2+1)*lg),	y+((i1+i2)*lg),		lg,   i1,	1-i2);
	peano(verts, x+lg,				y+lg,				lg,   i1,	1-i2);
	peano(verts, x+((i1+i2)*lg),	y+((i1-i2+1)*lg),	lg, 1-i1,	1-i2);
	peano(verts, x+(2*i2*lg),		y+(2*(1-i2)*lg),	lg,   i1,	  i2);
	peano(verts, x+((1+i2-i1)*lg),	y+((2-i1-i2)*lg),	lg,   i1,	  i2);
	peano(verts, x+(2*(1-i1)*lg),	y+(2*(1-i1)*lg),	lg,   i1,	  i2);
	peano(verts, x+((2-i1-i2)*lg),	y+((1+i2-i1)*lg),	lg, 1-i1,	  i2);
	peano(verts, x+(2*(1-i2)*lg),	y+(2*i2*lg),		lg, 1-i1,	  i2);
}

int
main(void)
{
	sfVideoMode mode = {window_side_len, window_side_len, 32};
	sfRenderWindow* window;
	sfEvent event;
	sfVideoMode vidmode;
	sfVector2i winpos;
	sfVertexArray *verts;

	/* this will end up holding peano_width^2 vertices */
	verts = sfVertexArray_create();
	sfVertexArray_setPrimitiveType(verts, sfLineStrip);

	/* Create the main window */
	window = sfRenderWindow_create(mode, "Peano Curve", sfResize | sfClose, NULL);
	if (!window)
		return EXIT_FAILURE;

	/* Centre the window */
	vidmode = sfVideoMode_getDesktopMode();
	winpos.x = vidmode.width/2 - window_side_len/2;
	winpos.y = vidmode.height/2 - window_side_len/2;
	sfRenderWindow_setPosition(window, winpos);

	/* Generate the vertices */
	peano(verts, 0, 0, peano_width, 0, 0);

	/* Start the event loop */
	while (sfRenderWindow_isOpen(window)) {
		/* Process events */
		while (sfRenderWindow_pollEvent(window, &event)) {
			/* Close window : exit */
			if (event.type == sfEvtClosed)
				sfRenderWindow_close(window);
		}

		sfRenderWindow_clear(window, sfBlack);
		/* Render the line */
		sfRenderWindow_drawVertexArray(window, verts, NULL);
		sfRenderWindow_display(window);
	}
	sfRenderWindow_destroy(window);

	return EXIT_SUCCESS;
}
