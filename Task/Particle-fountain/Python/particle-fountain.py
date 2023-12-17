# Using SDL2 library: # pip install PySDL2

import sys
import random
import time
import math

import sdl2
import sdl2.ext

FPS = 60
NEW_PARTICLES_PER_FRAME = 10
MAX_PARTICLES = 5_000
GRAVITY = 100
WIDTH = 640
HEIGHT = 480


def clamp(value, min_, max_):
    """Return value clamped between min and max"""
    return max(min_, min(value, max_))


class Particle:
    """Particle obeying gravity law."""

    def __init__(self):
        self.x = 0
        self.y = 0
        self.v_x = 0
        self.v_y = 0

    def update(self, dtime: float) -> None:
        """Move particle and update speed with gravity"""
        self.x = self.x + self.v_x * dtime
        self.y = self.y + self.v_y * dtime
        self.v_y = self.v_y + GRAVITY * dtime

    def set(self, x, y, v_x, v_y):
        """Set particle values"""
        self.x = x
        self.y = y
        self.v_x = v_x
        self.v_y = v_y


class Fountain:
    """The fountain"""

    def __init__(self, max_particles: int, particles_per_frame: int):
        self.particles_per_frame = particles_per_frame
        self.max_particles = max_particles
        self.spread = 10.0
        self.range = math.sqrt(2 * GRAVITY * (HEIGHT - 20 - self.spread))
        self.saturation = 155
        self.reciprocate = False
        self.reciprocating_time = 0.0
        self.particles = [
            self.init_particle(Particle()) for _ in range(self.particles_per_frame)
        ]

    def update(self, dtime) -> None:
        """Update particles"""
        if self.reciprocate:
            self.reciprocating_time += dtime

        for particle in self.particles:
            particle.update(dtime)
            if particle.y > HEIGHT - 10:
                self.init_particle(particle)

        if len(self.particles) < self.max_particles:
            for _ in range(self.particles_per_frame):
                self.particles.append(self.init_particle(Particle()))
            # print(len(particles))

    def render(self, renderer: sdl2.ext.renderer.Renderer) -> None:
        """Render particles"""
        points = [(particle.x, particle.y) for particle in self.particles]

        renderer.clear()
        renderer.draw_point(
            points, sdl2.ext.Color(self.saturation, self.saturation, 255)
        )
        renderer.present()

    def step_parameter(self, param, step):
        """Change parameters"""
        if param == "spread":
            self.spread = clamp(self.spread + step, 0, 50)
        elif param == "range":
            self.range = clamp(self.range + step, 0, 300)
        elif param == "color":
            self.saturation = clamp(self.saturation + step, 0, 255)
        elif param == "reciprocate":
            self.reciprocate = not self.reciprocate
            self.reciprocating_time = 0.0

    def init_particle(self, particle: Particle) -> Particle:
        """Move particle at initial position with a random-y speed"""
        radius = random.random() * self.spread
        direction = random.random() * math.pi * 2
        v_x = radius * math.cos(direction) + math.sin(self.reciprocating_time) * 20.0
        v_y = -self.range + radius * math.sin(direction)
        particle.set(WIDTH // 2, HEIGHT - 10, v_x, v_y)
        return particle


def make_renderer() -> sdl2.ext.renderer.Renderer:
    """Initialise SDL and make renderer"""
    sdl2.ext.init()

    window = sdl2.ext.Window("Particle Fountain", size=(WIDTH, HEIGHT))
    window.show()

    renderer = sdl2.ext.renderer.Renderer(window)

    return renderer


def limit_frame_rate(fps: float, cur_time: int) -> bool:
    """Limit frame rate"""
    dtime = time.monotonic_ns() - cur_time
    frame_duration = 1e9 / fps
    if dtime < frame_duration:
        time.sleep((frame_duration - dtime) / 1e9)
        return True
    return False


def handle_events(fountain: Fountain):
    """Act on events"""
    key_actions = {
        sdl2.SDL_SCANCODE_PAGEUP: lambda: fountain.step_parameter("color", 5),
        sdl2.SDL_SCANCODE_PAGEDOWN: lambda: fountain.step_parameter("color", -5),
        sdl2.SDL_SCANCODE_UP: lambda: fountain.step_parameter("range", 1),
        sdl2.SDL_SCANCODE_DOWN: lambda: fountain.step_parameter("range", -1),
        sdl2.SDL_SCANCODE_LEFT: lambda: fountain.step_parameter("spread", -1),
        sdl2.SDL_SCANCODE_RIGHT: lambda: fountain.step_parameter("spread", 1),
        sdl2.SDL_SCANCODE_SPACE: lambda: fountain.step_parameter("reciprocate", 1),
    }

    events = sdl2.ext.get_events()
    for event in events:
        if event.type == sdl2.SDL_QUIT:
            return False
        if event.type == sdl2.SDL_KEYDOWN:
            if event.key.keysym.scancode in key_actions:
                key_actions[event.key.keysym.scancode]()
            elif event.key.keysym.scancode == sdl2.SDL_SCANCODE_Q:
                return False
    return True


def main_loop(renderer: sdl2.ext.renderer.Renderer, fountain: Fountain) -> None:
    """Main animation loop"""
    running = True

    cur_time = time.monotonic_ns()
    while running:
        running = handle_events(fountain)

        fountain.render(renderer)

        if not limit_frame_rate(FPS, cur_time):
            print(f"Didn't make it in time with {len(fountain.particles)} particles.")

        dtime = (time.monotonic_ns() - cur_time) / 1e9  # in seconds
        fountain.update(dtime)
        cur_time = time.monotonic_ns()

    sdl2.ext.quit()


def run():
    """Start!"""

    renderer = make_renderer()
    fountain = Fountain(MAX_PARTICLES, NEW_PARTICLES_PER_FRAME)

    main_loop(renderer, fountain)

    return 0


if __name__ == "__main__":
    sys.exit(run())
