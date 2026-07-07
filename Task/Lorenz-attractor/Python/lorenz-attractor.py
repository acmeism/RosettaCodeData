""" Lorenz attractor task for Rosetta Code """

import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

SIGMA = 10.0
RHO = 28.0
BETA = 8.0 / 3.0
STEP_DT = 0.01


class LorenzAttractor:
    """ Lorenz attractor plotting data """
    def __init__(self, x=0.01, y=0.0, z=0.0):
        self.x = x
        self.y = y
        self.z = z
        self.points = []

    def step(self, dt=STEP_DT):
        """ Euler integration of larenz attractor """
        self.x += (SIGMA * (self.y - self.x)) * dt
        self.y += (self.x * (RHO - self.z) - self.y) * dt
        self.z += (self.x * self.y - BETA * self.z) * dt

        self.points.append((self.x * 10, self.y * 10))
        if len(self.points) > 2000:
            self.points.pop(0)


def make_lorenz():
    """ Plot Lorenz attractor into frames, then load frames as a .gif file """
    lorenz = LorenzAttractor()

    fig, ax = plt.subplots(figsize=(8, 6))
    fig.patch.set_facecolor("black")
    ax.set_facecolor("black")
    ax.set_aspect("equal")

    ax.set_xlim(-300, 300)
    ax.set_ylim(-300, 300)

    ax.set_xticks([])
    ax.set_yticks([])

    line, = ax.plot([], [], color="magenta", lw=1)

    def update(frame_number):
        """ Update plot, advancing simulation 10 steps per frame """
        for _ in range(10):
            lorenz.step()

        if len(lorenz.points) >= 2:
            xs, ys = zip(*lorenz.points)
            line.set_data(xs, ys)

        if frame_number % 400 == 0:
            print(
                f"Frame {frame_number}: "
                f"x={lorenz.x}, y={lorenz.y}, z={lorenz.z}"
            )

        return (line,)

    anim = FuncAnimation(
        fig,
        update,
        frames=1600,
        interval=20,
        blit=True,
    )

    anim.save("lorenz.gif", writer="pillow", fps=50)
    plt.show()


if __name__ == "__main__":
    make_lorenz()
