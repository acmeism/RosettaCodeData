import numpy as np
import pandas as pd

# =============================
# NKTg Planetary Verification
# =============================

# Table 1 – 30/12/2024 data (NASA)
planets_data = [
    # Planet, x (km), v (km/s), m (kg)
    ("Mercury", 6.9817930e7, 38.86, 3.301e23),
    ("Venus",   1.0893900e8, 35.02, 4.867e24),
    ("Earth",   1.4710000e8, 29.29, 5.972e24),
    ("Mars",    2.4923000e8, 24.07, 6.417e23),
    ("Jupiter", 8.1662000e8, 13.06, 1.898e27),
    ("Saturn",  1.5065300e9, 9.69,  5.683e26),
    ("Uranus",  3.0013900e9, 6.8,   8.681e25),
    ("Neptune", 4.5589000e9, 5.43,  1.024e26),
]

df = pd.DataFrame(planets_data, columns=["Planet", "x_km", "v_km_s", "m_kg"])

# Convert to SI units
df["x_m"] = df["x_km"] * 1e3
df["v_m_s"] = df["v_km_s"] * 1e3

# Linear momentum
df["p"] = df["m_kg"] * df["v_m_s"]

# NKTg₁
df["NKTg1"] = df["x_m"] * df["p"]

# Interpolated mass (31/12/2024)
df["m_interpolated"] = df["NKTg1"] / (df["x_m"] * df["v_m_s"])

# Mass difference
df["delta_m"] = df["m_kg"] - df["m_interpolated"]

print("=== NKTg Planetary Mass Verification ===")
print(df[["Planet", "m_kg", "m_interpolated", "delta_m"]])

# =============================
# Earth 2024 Interpolation
# =============================

# NKTg₁ from 31/12/2023
NKTg1_earth = 2.664e33

earth_2024_data = [
    ("20240101", 149600000, 29.779),
    ("20240401", 149500000, 29.289),
    ("20240701", 149400000, 30.289),
    ("20241001", 149500000, 29.779),
    ("20241231", 149600000, 29.779),
]

earth_df = pd.DataFrame(earth_2024_data, columns=["Date", "x_km", "v_km_s"])
earth_df["x_m"] = earth_df["x_km"] * 1e3
earth_df["v_m_s"] = earth_df["v_km_s"] * 1e3

# Interpolated mass 2024
earth_df["m_interpolated"] = NKTg1_earth / (earth_df["x_m"] * earth_df["v_m_s"])

# NASA fixed mass
earth_df["m_nasa_fixed"] = 5.9722e24

# Difference
earth_df["delta_m"] = earth_df["m_nasa_fixed"] - earth_df["m_interpolated"]

print("\n=== Earth 2024 Mass Interpolation (NKTg) ===")
print(earth_df[["Date", "m_interpolated", "m_nasa_fixed", "delta_m"]])
