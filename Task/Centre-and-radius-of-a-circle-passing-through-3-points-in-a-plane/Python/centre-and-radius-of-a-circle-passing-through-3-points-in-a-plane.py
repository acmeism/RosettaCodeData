# 3pt_center_radius.py by Xing216
# https://math.stackexchange.com/questions/213658/get-the-equation-of-a-circle-when-given-3-points
# https://web.archive.org/web/20060909065617/http://www.math.okstate.edu/~wrightd/INDRA/MobiusonCircles/node4.html
def circle_from_3_points(z1:complex, z2:complex, z3:complex) -> tuple[complex, float]:
    if (z1 == z2) or (z2 == z3) or (z3 == z1):
        raise ValueError(f"Duplicate points: {z1}, {z2}, {z3}")

    w = (z3 - z1)/(z2 - z1)

    # You should change 0 to a small tolerance for floating point comparisons
    if abs(w.imag) <= 0:
        raise ValueError(f"Points are collinear: {z1}, {z2}, {z3}")

    c = (z2 - z1)*(w - abs(w)**2)/(2j*w.imag) + z1  # Simplified denominator
    r = abs(z1 - c)

    return c, r

center, radius = circle_from_3_points(22.83+2.07j,14.39+30.24j,33.65+17.31j)

print(f"centerpoint: ({round(center.real,2)}, {round(center.imag, 2)})\nradius: {round(radius, 2)}")
