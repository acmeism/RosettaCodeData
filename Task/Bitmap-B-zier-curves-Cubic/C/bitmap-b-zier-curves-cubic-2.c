#include <math.h>

/* number of segments for the curve */
#define N_SEG 20

#define plot(x, y) put_pixel_clip(img, x, y, r, g, b)
#define line(x0,y0,x1,y1) draw_line(img, x0,y0,x1,y1, r,g,b)

void cubic_bezier(
       	image img,
        unsigned int x1, unsigned int y1,
        unsigned int x2, unsigned int y2,
        unsigned int x3, unsigned int y3,
        unsigned int x4, unsigned int y4,
        color_component r,
        color_component g,
        color_component b )
{
    unsigned int i;
    double pts[N_SEG+1][2];
    for (i=0; i <= N_SEG; ++i)
    {
        double t = (double)i / (double)N_SEG;

        double a = pow((1.0 - t), 3.0);
        double b = 3.0 * t * pow((1.0 - t), 2.0);
        double c = 3.0 * pow(t, 2.0) * (1.0 - t);
        double d = pow(t, 3.0);

        double x = a * x1 + b * x2 + c * x3 + d * x4;
        double y = a * y1 + b * y2 + c * y3 + d * y4;
        pts[i][0] = x;
        pts[i][1] = y;
    }

#if 0
    /* draw only points */
    for (i=0; i <= N_SEG; ++i)
    {
        plot( pts[i][0],
              pts[i][1] );
    }
#else
    /* draw segments */
    for (i=0; i < N_SEG; ++i)
    {
        int j = i + 1;
	line( pts[i][0], pts[i][1],
              pts[j][0], pts[j][1] );
    }
#endif
}
#undef plot
#undef line
