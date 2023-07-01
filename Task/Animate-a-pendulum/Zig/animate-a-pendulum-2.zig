pub fn main() void {
    c.SetConfigFlags(c.FLAG_VSYNC_HINT);
    c.InitWindow(640, 320, "Pendulum");
    defer c.CloseWindow();

    // Simulation constants.
    const g = 9.81; // Gravity (should be positive).
    const length = 5.0; // Pendulum length.
    const theta0 = math.pi / 3.0; // Initial angle for which omega = 0.

    const e = g * length * (1 - @cos(theta0)); // Total energy = potential energy when starting.

    // Simulation variables.
    var theta: f32 = theta0; // Current angle.
    var omega: f32 = 0; // Angular velocity = derivative of theta.
    var accel: f32 = -g / length * @sin(theta0); // Angular acceleration = derivative of omega.

    c.SetTargetFPS(60);

    while (!c.WindowShouldClose()) // Detect window close button or ESC key
    {
        const half_width = @as(f32, @floatFromInt(c.GetScreenWidth())) / 2;
        const pivot = c.Vector2{ .x = half_width, .y = 0 };

        // Compute the position of the mass.
        const mass = c.Vector2{
            .x = 300 * @sin(theta) + pivot.x,
            .y = 300 * @cos(theta),
        };

        {
            c.BeginDrawing();
            defer c.EndDrawing();

            c.ClearBackground(c.RAYWHITE);

            c.DrawLineV(pivot, mass, c.GRAY);
            c.DrawCircleV(mass, 20, c.GRAY);
        }

        // Update theta and omega.
        const dt = c.GetFrameTime();
        theta += (omega + dt * accel / 2) * dt;
        omega += accel * dt;

        // If, due to computation errors, potential energy is greater than total energy,
        // reset theta to ±theta0 and omega to 0.
        if (length * g * (1 - @cos(theta)) >= e) {
            theta = math.sign(theta) * theta0;
            omega = 0;
        }
        accel = -g / length * @sin(theta);
    }
}
