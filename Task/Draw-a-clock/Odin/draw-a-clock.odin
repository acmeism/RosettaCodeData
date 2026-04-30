package clock

import rl "vendor:raylib"
import "core:time"
import "core:time/datetime"
import "core:time/timezone"
import "core:os"
import "core:math"

TimePeriod :: enum {
	AM,
	PM
}

DistanceAngle :: proc(distance: f32, angle: f32) -> (vector: rl.Vector2) {
	vector.x = math.sin_f32(angle)
	vector.y = -math.cos_f32(angle)
	vector *= distance

	return
}

main :: proc() {
	tz, ok := timezone.region_load("local")

	rl.SetConfigFlags({.MSAA_4X_HINT})
	rl.InitWindow(640, 480, "Rosetta Code - draw a clock")

	screen_center := rl.Vector2 {f32(rl.GetScreenWidth()) / 2, f32(rl.GetScreenHeight()) / 2}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.RAYWHITE)

		conversion_succeeded: bool = true
		date_time: datetime.DateTime
		date_time, ok = time.time_to_datetime(time.now())
		if !ok do conversion_succeeded = false

		date_time, ok = timezone.datetime_to_tz(date_time, tz)
		if !ok do conversion_succeeded = false

		regular_time: time.Time
		regular_time, ok = time.datetime_to_time(date_time)
		if !ok do conversion_succeeded = false

		if !conversion_succeeded do os.exit(1)

		period: TimePeriod
		hour, min, sec := time.clock_from_time(regular_time)
		if hour > 12 {
			hour -= 12
			period = .PM
		}

		radius := f32(rl.GetScreenHeight()) / 2.5

		rl.DrawCircleV(screen_center, radius, rl.LIGHTGRAY)

		rl.DrawLineEx(screen_center, screen_center + DistanceAngle(radius * .75, (f32(hour) / 12) * math.TAU), 4, rl.BLACK)
		rl.DrawLineEx(screen_center, screen_center + DistanceAngle(radius * .7, (f32(min) / 60) * math.TAU), 4, rl.DARKGREEN)
		rl.DrawLineEx(screen_center, screen_center + DistanceAngle(radius * .5, (f32(sec) / 60) * math.TAU), 4, rl.RED)

		for i := 0; i < 60; i += 1 {
			angle := (f32(i) / 60) * math.TAU

			inside_distance: f32 = .8
			thickness: f32 = 1.5

			if i % 5 == 0 {
				inside_distance = .775
				thickness = 3
			}
			
			rl.DrawLineEx(screen_center + DistanceAngle(radius * inside_distance, angle), screen_center + DistanceAngle(radius * .95, angle), thickness, rl.DARKGRAY)
		}

		//fmt.printfln("%2d:%2d:%2d %s", hour, min, sec, period)

		rl.EndDrawing()
	}

	rl.CloseWindow()

	timezone.region_destroy(tz)
}
