import "./dynamic" for Struct
import "./fmt" for Fmt

var fields = [
    "date",
    "x",  // position (m)
    "v",  // velocity (m/s)
    "m"   // mass (kg)
]
var MercuryData = Struct.create("MercuryData", fields)

// ================================
// 1. NASA 2024 Reference Data
// ================================
var reference_2024 = MercuryData.new("31/12/2024", 4.64e10, 5.81e4, 3.30e23)

var p_ref = reference_2024.m * reference_2024.v
var nktg1_constant = reference_2024.x * p_ref

Fmt.print("NKTg₁ reference constant: $0.3fe38", nktg1_constant / 1e38)
Fmt.print("========================================\n")

// ================================
// 2. NASA 2025 Real Data
// ================================
var nasa_2025 = [
    MercuryData.new("01/01/2025", 5.16e10, 5.34e4, 3.30e23),
    MercuryData.new("01/04/2025", 6.97e10, 3.89e4, 3.30e23),
    MercuryData.new("01/07/2025", 5.49e10, 5.04e4, 3.30e23),
    MercuryData.new("01/10/2025", 6.83e10, 3.98e4, 3.30e23),
    MercuryData.new("31/12/2025", 4.61e10, 5.89e4, 3.30e23),
]

// Mass variation rate (MESSENGER data)
var dm_dt = -0.5 // kg/s

System.print("Date             v_NKTg       v_NASA    Rel.Error(\%)      NKTg₂")
System.print("-----------------------------------------------------------------------")

for (data in nasa_2025) {

    // Interpolated velocity from constant NKTg1
    var v_nktg = nktg1_constant / (data.x * data.m)

    // Relative error
    var rel_error = ((v_nktg - data.v) / data.v) * 100.0

    // Momentum
    var p = data.m * v_nktg

    // NKTg2 calculation
    var nktg2 = dm_dt * p

    Fmt.print("$-12s $9.3fe04 $9.3fe04 $10.4f $12.3fe27",
        data.date,
        v_nktg / 1e4,
        data.v / 1e4,
        rel_error,
        nktg2 / 1e27
    )
}

System.print("\n========================================")
System.print("Interpretation:")
System.print("NKTg₁ maintained as constant.")
System.print("NKTg₂ negative → mass variation resists motion.")
