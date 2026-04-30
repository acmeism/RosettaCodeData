package main

import "core:bytes"
import "core:fmt"
import "core:image/bmp"
import "core:math"
import "core:math/linalg"

Vec2 :: [2]f32
Color :: bmp.RGB_Pixel

// Adapted from
// https://github.com/raysan5/raylib/blob/5aa3f0ccc374c1fbfc880402b37871b9c3bb7d8e/src/rtextures.c#L4936
//
// Hue is provided in degrees: [0..360]
//
// Saturation/Value are provided normalized: [0.0f..1.0f]
from_hsv :: proc(hue, saturation, value: f32) -> Color {
	pixel := Color{0, 0, 0}
	k, t: f32

	// Red channel
	k = math.mod((5.0 + hue / 60.0), 6)
	t = 4.0 - k
	k = (t < k) ? t : k
	k = (k < 1) ? k : 1
	k = (k > 0) ? k : 0
	pixel.r = u8((value - value * saturation * k) * 255.0)

	// Green channel
	k = math.mod((3.0 + hue / 60.0), 6)
	t = 4.0 - k
	k = (t < k) ? t : k
	k = (k < 1) ? k : 1
	k = (k > 0) ? k : 0
	pixel.g = u8((value - value * saturation * k) * 255.0)

	// Blue channel
	k = math.mod((1.0 + hue / 60.0), 6)
	t = 4.0 - k
	k = (t < k) ? t : k
	k = (k < 1) ? k : 1
	k = (k > 0) ? k : 0
	pixel.b = u8((value - value * saturation * k) * 255.0)

	return pixel
}

main :: proc() {
	img_size :: 1000
	img_buff: bytes.Buffer
	img := bmp.Image {
		width    = img_size,
		height   = img_size,
		channels = 3,
		depth    = 8,
		pixels   = img_buff,
		which    = .BMP,
	}
	bmp.make_output(&img)

	for x in 0 ..< img_size {
		for y in 0 ..< img_size {
			radius :: img_size / 2
			center :: Vec2{radius, radius}
			color := Color{0x1e, 0x1e, 0x1e}

			fx, fy := f32(x), f32(y)

			// if distance from current pixel to center of image is less than radius - we inside of the colorwheel
			dist := linalg.distance(center, Vec2{fx, fy})
			if (dist <= radius) {
				// angle between x-axis and line from center to pixel in radians
				angle := math.atan2(fx - center.x, fy - center.y)
				// convert from radian to degree
				hue := angle * (180 / math.PI)
				// normalize distance to [0..1] range and use as saturation
				sat := dist / radius
				color = from_hsv(hue, sat, 1)
			}
			err := bmp.write(&img, x, y, color)
			if err != nil do fmt.panicf("Error writing pixel: ", err)
		}
	}

	err := bmp.save_to_file("wheel.bmp", &img)
	if err != nil do fmt.panicf("Error saving image: ", err)
	bytes.buffer_destroy(&img_buff)
}
