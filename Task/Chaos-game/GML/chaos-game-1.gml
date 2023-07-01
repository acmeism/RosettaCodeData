offset = 32; //Distance from triangle vertices to edges of window

//triangle vertex coordinates
x1 = room_width / 2;
y1 = offset;
x2 = room_width - offset;
y2 = room_height - offset;
x3 = offset;
y3 = room_height - offset;

//Coords of randomly chosen vertex (set to 0 to start, will automatically be set in step event)
vx = 0;
vy = 0;

//Coords of current point
px = random(room_width);
py = random(room_height);

//Make sure the point is within the triangle
while(!point_in_triangle(px, py, x1, y1, x2, y2, x3, y3))
{
	px = random(room_width);
	py = random(room_height);
}

vertex = 0; //This determines which vertex coords are chosen
max_iterations = 8000;
step = true; //Used with the interval alarm to change the step speed
step_count = 0;
interval = 1; //Number of frames between each step. 1 = no delay
alarm[0] = interval;
