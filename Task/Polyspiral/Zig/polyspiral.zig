const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});

const SCREEN_WIDTH = 640;
const SCREEN_HEIGHT = 480;
var incr: f32 = 0;

pub fn main() void {
    rl.SetConfigFlags(rl.FLAG_WINDOW_RESIZABLE | rl.FLAG_VSYNC_HINT);
    rl.SetTargetFPS(60);

    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Polyspiral");

    while (!rl.WindowShouldClose())
        updateDrawFrame();

    rl.CloseWindow();
}

fn updateDrawFrame() void {
    rl.BeginDrawing();

    rl.ClearBackground(rl.BLACK);

    incr = @mod(incr + 0.001, 360);

    drawSpiral(5, std.math.degreesToRadians(f32, incr));

    rl.EndDrawing();
}

fn drawSpiral(_length: f32, _angle: f32) void {
    const width = rl.GetScreenWidth();
    const height = rl.GetScreenHeight();
    var point0 = rl.Vector2{ .x = @as(f32, @floatFromInt(width)) / 2, .y = @as(f32, @floatFromInt(height)) / 2 };
    var length = _length;
    var angle = _angle;
    for (0..150) |_| {
        const line_vector = rl.Vector2Rotate(rl.Vector2{ .x = length, .y = 0 }, angle);
        const point1 = rl.Vector2Add(point0, line_vector);
        rl.DrawLineV(point0, point1, rl.LIME);
        point0 = point1;
        length += 3;
        angle += incr;
        angle = @mod(angle, comptime @as(f32, (2.0 * std.math.pi)));
    }
}
