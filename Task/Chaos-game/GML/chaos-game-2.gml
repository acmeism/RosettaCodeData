if(step and step_count < max_iterations) //Wait for alarm to finish, or stop completely
{										// if the desired number of iterations is hit
	vertex = choose(1, 2, 3);
	step = false;
	alarm[0] = interval;
	switch(vertex)
	{
		case 1:
			vx = x1;
			vy = y1;
		break;
	
		case 2:
			vx = x2;
			vy = y2;
		break;
	
		case 3:
			vx = x3;
			vy = y3;
		break;
	}

	var dir = point_direction(px, py, vx, vy);
	var mid_dist = point_distance(px, py, vx, vy);
	var midx = px + lengthdir_x(mid_dist / 2, dir);
	var midy = py + lengthdir_y(mid_dist / 2, dir);
	instance_create_layer(midx, midy, "Instances", Point);

	px = midx;
	py = midy;
	
	step_count++;
}
