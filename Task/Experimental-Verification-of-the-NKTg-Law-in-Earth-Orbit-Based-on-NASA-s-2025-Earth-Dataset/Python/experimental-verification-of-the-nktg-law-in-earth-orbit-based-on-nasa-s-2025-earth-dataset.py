from dataclasses import dataclass

DM_PER_DT = -1.8


@dataclass
class EarthOrbital:
    date: str
    position: float  # m
    velocity: float  # m/s
    mass: float  # kg


def momentum(m: float, v: float) -> float:
    return m * v


def nktg1(x: float, p: float) -> float:
    return x * p


def nktg2(p: float) -> float:
    return DM_PER_DT * p


def relative_error(simulation: float, observed: float) -> float:
    return (simulation / observed - 1) * 100.0


def main():
    # Simulated data (NKTg 2025)
    sim_2025 = [
        EarthOrbital("01/01/2025", 1.471012e11, 3.0276e4, 5.97219e24),
        EarthOrbital("04/01/2025", 1.494953e11, 2.9791e4, 5.97218999999998e24),
        EarthOrbital("07/01/2025", 1.520965e11, 2.9282e4, 5.97218999999997e24),
        EarthOrbital("10/01/2025", 1.496328e11, 2.9764e4, 5.97218999999995e24),
        EarthOrbital("12/31/2025", 1.471025e11, 3.0276e4, 5.97218999999994e24),
    ]

    # Observed data
    nasa_velocities = [3.0287e4, 2.9791e4, 2.9291e4, 2.9778e4, 3.0286e4]

    print("\nExperimental Verification of NKTg Law (Earth 2025)\n")

    header = f"{'Date':<12} {'Momentum(p)':>12} {'NKTg1':>12} {'NKTg2':>12} {'v_sim':>10} {'v_NASA':>10} {'Error':>10}"
    print(header)
    print("-" * len(header))

    for data, v_nasa in zip(sim_2025, nasa_velocities):
        p = momentum(data.mass, data.velocity)
        n1 = nktg1(data.position, p)
        n2 = nktg2(p)
        error = relative_error(data.velocity, v_nasa)

        print(
            f"{data.date:<12} {p:>12.2e} {n1:>12.2e} {n2:>12.2e} "
            f"{data.velocity:>10.1f} {v_nasa:>10.1f} {error:>9.4f}%"
        )


if __name__ == "__main__":
    main()

