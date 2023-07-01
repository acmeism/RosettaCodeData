if(step_count < max_iterations)
{
	draw_triangle(x1, y1, x2, y2, x3, y3, true);
	draw_circle(px, py, 1, false);
	draw_line(px, py, vx, vy);
}
