def nktg(x, v, m, dm_dt):
    p = m * v
    nktg1 = x * p
    nktg2 = dm_dt * p

    if nktg1 > 0:
        tendency1 = "Moving away from stable state"
    elif nktg1 < 0:
        tendency1 = "Moving toward stable state"
    else:
        tendency1 = "Stable equilibrium"

    if nktg2 > 0:
        tendency2 = "Mass variation supports movement"
    elif nktg2 < 0:
        tendency2 = "Mass variation resists movement"
    else:
        tendency2 = "No mass variation effect"

    return {
        "p": p,
        "NKTg1": nktg1,
        "NKTg2": nktg2,
        "Tendency1": tendency1,
        "Tendency2": tendency2
    }

# Example
result = nktg(2, 3, 4, -0.5)
print(result)
