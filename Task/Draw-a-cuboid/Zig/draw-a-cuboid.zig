const std = @import("std");
const c = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    c.SetConfigFlags(c.FLAG_WINDOW_RESIZABLE | c.FLAG_VSYNC_HINT);
    c.InitWindow(600, 480, "cuboid");
    defer c.CloseWindow();

    const camera = c.Camera3D{
        .position = .{ .x = 4.5, .y = 4.5, .z = 4.5 },
        .target = .{ .x = 0, .y = 0, .z = 0 },
        .up = .{ .x = 0, .y = 1, .z = 0 },
        .fovy = 45.0,
        .projection = c.CAMERA_PERSPECTIVE,
    };

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) {
        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(c.BLACK);

        {
            c.BeginMode3D(camera);
            defer c.EndMode3D();

            c.DrawCubeWires(.{ .x = 0, .y = 0, .z = 0 }, 2, 3, 4, c.LIME);
        }
    }
}
