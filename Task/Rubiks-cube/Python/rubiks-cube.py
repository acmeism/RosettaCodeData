""" Draw Rubik's cube task for Rosetta Code """

import matplotlib.pyplot as plt
from matplotlib import patches


def draw_rubiks_cube():
    """ Draw the 3D cube with differently colored face squares """
    # Create figure and axis
    _, ax = plt.subplots(figsize=(8, 8))
    ax.set_aspect('equal')
    ax.set_xlim(-200, 200)
    ax.set_ylim(-200, 200)
    ax.axis('off')  # Hide axes

    s = 40      # cell size in pixels
    skx = 20    # horizontal skew per depth step
    sky = -12   # vertical skew per depth step (negative = upward on screen)
    fx, fy = -90, 78  # Bottom-left corner of the front face
    # Color tables — [visualrow, visualcol] for front/right, [depthrow, col] for top
    front_colors = [
        ["red", "red", "green"],
        ["red", "blue", "green"],
        ["blue", "blue", "green"]
    ]

    top_colors = [
        ["yellow", "orange", "white"],
        ["yellow", "orange", "white"],
        ["yellow", "white", "orange"]
    ]

    right_colors = [
        ["orange", "blue", "orange"],
        ["white", "white", "white"],
        ["blue", "orange", "blue"]
    ]

    # Helper function to draw a polygon
    def drawcell(corners, color):
        # Rotate 180 degrees from julia's due to different orientation of drawing in matplotlib
        rotated_corners = [(-x, -y) for x, y in corners]
        polygon = patches.Polygon(
            rotated_corners, facecolor=color, edgecolor='black', linewidth=2)
        ax.add_patch(polygon)

    # Front face
    for j in range(3):
        for i in range(3):
            x = fx + i * s
            y = fy - (3 - j) * s
            corners = [(x, y), (x+s, y), (x+s, y+s), (x, y+s)]
            drawcell(corners, front_colors[j][i])

    # Top face
    for k in range(3):
        for i in range(3):
            x0 = fx + i*s + k*skx
            y0 = (fy - 3*s) + k*sky
            corners = [
                (x0, y0),
                (x0 + s, y0),
                (x0 + s + skx, y0 + sky),
                (x0 + skx, y0 + sky)
            ]
            drawcell(corners, top_colors[k][i])

    # Right face
    for k in range(3):
        for j in range(3):
            x0 = fx + 3*s + k*skx
            y0 = fy - (3 - j)*s + k*sky
            corners = [
                (x0, y0),
                (x0 + skx, y0 + sky),
                (x0 + skx, y0 + sky + s),
                (x0, y0 + s)
            ]
            drawcell(corners, right_colors[j][k])

    plt.tight_layout()
    plt.savefig('rubikscube.png', dpi=100, bbox_inches='tight')
    plt.show()


# Call the function
draw_rubiks_cube()
