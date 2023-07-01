#!/usr/bin/env dub
/+ dub.sdl:
	dependency "dlib" version="~>0.21.0"
+/
import std.random;

import dlib.image;

void main()
{
	enum WIDTH = 640;
	enum HEIGHT = 640;
	enum ITERATIONS = 2E6;

	float x = 0.0f;
	float y = 0.0f;

	auto rng = Random(unpredictableSeed);
	auto color = Color4f(0.0f, 1.0f, 0.0f);
	auto img = image(WIDTH, HEIGHT);

	foreach (_; 0..ITERATIONS)
	{
		auto r = uniform(0, 101, rng);
		
		if (r <= 1)
		{
			x = 0.0;
			y = 0.16 * y;
		}
		else
		{
			if (r <= 8)
			{
				x = 0.20 * x - 0.26 * y;
				y = 0.23 * x + 0.22 * y + 1.60;
			}
			else
			{
				if (r <= 15)
				{
					x = -0.15 * x + 0.28 * y;
					y = 0.26 * x + 0.24 * y + 0.44;
				}
				else
				{
					x = 0.85 * x + 0.04 * y;
					y = -0.04 * x + 0.85 * y + 1.6;
				}
			}
		}
		auto X = cast(int) (WIDTH / 2.0 + x * 60);
		auto Y =  HEIGHT - cast(int)(y * 60);
		img[X, Y] = color;
	}
	img.saveImage(`barnsley_dlib.png`);
}
