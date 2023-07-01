/* #include <sys/queue.h> */
typedef struct {
  color_component red, green, blue;
} rgb_color;
typedef rgb_color *rgb_color_p;

void floodfill(image img, int px, int py,
	       rgb_color_p bankscolor,
	       rgb_color_p rcolor);
