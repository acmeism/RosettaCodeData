#include "imglib.h"

typedef struct _ffill_node {
  int px, py;
  TAILQ_ENTRY(_ffill_node) nodes;
} _ffill_node_t;
TAILQ_HEAD(_ffill_queue_s, _ffill_node);
typedef struct _ffill_queue_s _ffill_queue;

inline void _ffill_removehead(_ffill_queue *q)
{
  _ffill_node_t *n = q->tqh_first;
  if ( n != NULL ) {
    TAILQ_REMOVE(q, n, nodes);
    free(n);
  }
}

inline void _ffill_enqueue(_ffill_queue *q, int px, int py)
{
  _ffill_node_t *node;
  node = malloc(sizeof(_ffill_node_t));
  if ( node != NULL ) {
    node->px = px; node->py = py;
    TAILQ_INSERT_TAIL(q, node, nodes);
  }
}

inline double color_distance( rgb_color_p a, rgb_color_p b )
{
  return sqrt( (double)(a->red - b->red)*(a->red - b->red) +
	       (double)(a->green - b->green)*(a->green - b->green) +
	       (double)(a->blue - b->blue)*(a->blue - b->blue) ) / (256.0*sqrt(3.0));
}

inline void _ffill_rgbcolor(image img, rgb_color_p tc, int px, int py)
{
  tc->red = GET_PIXEL(img, px, py)[0];
  tc->green = GET_PIXEL(img, px, py)[1];
  tc->blue = GET_PIXEL(img, px, py)[2];
}


#define NSOE(X,Y) do {							\
    if ( ((X)>=0)&&((Y)>=0) && ((X)<img->width)&&((Y)<img->height)) {	\
      _ffill_rgbcolor(img, &thisnode, (X), (Y));			\
      if ( color_distance(&thisnode, bankscolor) > tolerance ) {	\
	if (color_distance(&thisnode, rcolor) > 0.0) { 			\
	  put_pixel_unsafe(img, (X), (Y), rcolor->red,			\
			   rcolor->green,				\
			   rcolor->blue);				\
	  _ffill_enqueue(&head, (X), (Y));				\
	  pixelcount++;							\
	}								\
      }									\
    }									\
  } while(0)


unsigned int floodfill(image img, int px, int py,
	       rgb_color_p bankscolor,
	       rgb_color_p rcolor)
{
  _ffill_queue head;
  rgb_color thisnode;
  unsigned int pixelcount = 0;
  double tolerance = 0.05;

  if ( (px < 0) || (py < 0) || (px >= img->width) || (py >= img->height) )
    return;

  TAILQ_INIT(&head);

  _ffill_rgbcolor(img, &thisnode, px, py);
  if ( color_distance(&thisnode, bankscolor) <= tolerance ) return;

  _ffill_enqueue(&head, px, py);
  while( head.tqh_first != NULL ) {
    _ffill_node_t *n = head.tqh_first;
    _ffill_rgbcolor(img, &thisnode, n->px, n->py);
    if ( color_distance(&thisnode, bankscolor) > tolerance ) {
      put_pixel_unsafe(img, n->px, n->py, rcolor->red, rcolor->green, rcolor->blue);
      pixelcount++;
    }
    int tx = n->px, ty = n->py;
    _ffill_removehead(&head);
    NSOE(tx - 1, ty);
    NSOE(tx + 1, ty);
    NSOE(tx, ty - 1);
    NSOE(tx, ty + 1);
  }
  return pixelcount;
}
