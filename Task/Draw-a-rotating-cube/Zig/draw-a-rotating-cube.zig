const std = @import("std");
const c = @cImport({
    @cInclude("raylib.h");
    @cInclude("rlgl.h");
});

const dark_mode = true;
const show_grid = false;

pub fn main() !void {
    const screen_width = 640;
    const screen_height = 360;

    const cube_side = 1;
    const size = c.Vector3{ .x = cube_side, .y = cube_side, .z = cube_side };
    const position = c.Vector3{ .x = 0, .y = 0, .z = 0 };
    const x_rot = 45;
    const y_center = std.math.sqrt(@as(f32, 3)) * cube_side / 2;
    const z_rot = std.math.atan(@as(f32, std.math.sqrt1_2)) * 180 / std.math.pi;

    c.SetConfigFlags(c.FLAG_WINDOW_RESIZABLE | c.FLAG_VSYNC_HINT);
    c.InitWindow(screen_width, screen_height, "Draw a Rotating Cube");
    defer c.CloseWindow();

    var camera = c.Camera{
        .position = .{ .x = 3, .y = 3, .z = 3 },
        .target = .{ .x = 0, .y = y_center, .z = 0 }, // Center of cube
        .up = .{ .x = 0, .y = 1, .z = 0 },
        .fovy = 45, // Camera field-of-view Y
        .projection = c.CAMERA_PERSPECTIVE,
    };

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        c.UpdateCamera(&camera, c.CAMERA_ORBITAL);

        c.BeginDrawing();
        defer c.EndDrawing();

        c.ClearBackground(if (dark_mode) c.BLACK else c.RAYWHITE);
        {
            c.BeginMode3D(camera);
            defer c.EndMode3D();
            {
                c.rlPushMatrix();
                defer c.rlPopMatrix();
                c.rlTranslatef(0, y_center, 0);
                c.rlRotatef(z_rot, 0, 0, 1);
                c.rlRotatef(x_rot, 1, 0, 0);
                c.DrawCubeWiresV(position, size, if (dark_mode) c.LIME else c.BLACK);
            }
            if (show_grid) c.DrawGrid(12, 0.75);
        }
    }
}
