using Printf

""" The data for one light pulse. """
mutable struct PulseData
    logS::Int
    logL::Int
    logR::Int
    detectedL1::Int
    detectedL2::Int
    detectedR1::Int
    detectedR2::Int
end

""" Swap detectedL1 and detectedL2. """
swap_L_channels(p) = begin p.detectedL1, p.detectedL2 = p.detectedL2, p.detectedL1; p end


""" Swap detectedR1 and detectedR2. """
swap_R_channels(p) = begin p.detectedR1, p.detectedR2 = p.detectedR2, p.detectedR1; p end

"""
Swap channels on both right and left. This is done if the light source was (1,90°)
instead of (1,0°). For in that case the orientations of the polarizing beam splitters,
relative to the light source, is different by 90°.
"""
swap_LR_channels(p::PulseData) = (swap_L_channels(p); swap_R_channels(p))


"""
Split the data into two subsets, according to whether a set item satisfies a predicate.
The return value is a tuple, with those items satisfying the predicate in the first
tuple entry, the other items in the second entry.
"""
split_data(predicate, data) = (filter(predicate, data), filter(!predicate, data))

"""
Some data items are for a (1,0°) light pulse. The others are for a (1,90°) light pulse.
Thus the light pulses are oriented differently with respect to the polarizing beam splitters.
We adjust for that distinction here.
"""
function adjust_data_for_light_pulse_orientation(data)
    data0, data90 = split_data(x -> x.logS == 0, data)
    return vcat(data0, swap_LR_channels.(data90))
end

"""
Split the data into subsets per each arrangement of polarizing beam splitters.
"""
function split_data_according_to_PBS_setting(data)
    dataL1, dataL2 = split_data(x -> x.logL == 0, data)
    dataL1R1, dataL1R2 = split_data(x -> x.logR == 0, dataL1)
    dataL2R1, dataL2R2 = split_data(x -> x.logR == 0, dataL2)
    return (dataL1R1, dataL1R2, dataL2R1, dataL2R2)
end

"""
Compute the correlation coefficient for the subset of the data that corresponding
to a particular setting of the polarizing beam splitters.
"""
function compute_correlation_coefficient(angleL, angleR, data)

    # We make certain the orientations of beam splitters are
    # represented by perpendicular angles in the first and fourth
    # quadrant. This restriction causes no loss of generality, because
    # the orientation of the beam splitter is actually a rotated "X".
    @assert all(0 <= x < 90 for x in (angleL, angleR)) "All orientations are acute angles"

    # Note that the sine is non-negative in Quadrant 1, and the cosine
    # is non-negative in Quadrant 4. Thus we can use the following
    # estimates for cosine and sine. This is Equation (2.4) in the
    # reference. (Note, one can also use Quadrants 1 and 2 and reverse
    # the roles of cosine and sine. And so on like that.)
    N = length(data)
    NL1 = 0
    NL2 = 0
    NR1 = 0
    NR2 = 0
    for item in data
        NL1 += item.detectedL1
        NL2 += item.detectedL2
        NR1 += item.detectedR1
        NR2 += item.detectedR2
    end
    sinL = sqrt(NL1 / N)
    cosL = sqrt(NL2 / N)
    sinR = sqrt(NR1 / N)
    cosR = sqrt(NR2 / N)

    # Now we can apply the reference's Equation (2.3).
    cosLR = (cosR * cosL) + (sinR * sinL)
    sinLR = (sinR * cosL) - (cosR * sinL)

    # And then Equation (2.5).
    kappa = (cosLR * cosLR) - (sinLR * sinLR)

    return kappa
end

""" Read the raw data. Its order does not actually matter. """
function read_raw_data(stream)
    return [PulseData(row...) for row in filter(a -> length(a) == 7,
              [[parse(Int, s) for s in split(line)] for line in readlines(stream)])]
end

function run_analysis(inputstream)
    # Polarizing beam splitter orientations commonly used in actual
    # experiments. These must match the values used in the simulation
    # itself. They are by design all either zero degrees or in the
    # first quadrant.
    anglesL = [0.0, 45.0]
    anglesR = [22.5, 67.5]
    @assert all(0 <= x < 90 for x in [anglesL; anglesR])

    data = read_raw_data(inputstream) |> adjust_data_for_light_pulse_orientation
    dataL1R1, dataL1R2, dataL2R1, dataL2R2 = split_data_according_to_PBS_setting(data)

    kappaL1R1 = compute_correlation_coefficient(anglesL[1], anglesR[1], dataL1R1)
    kappaL1R2 = compute_correlation_coefficient(anglesL[1], anglesR[2], dataL1R2)
    kappaL2R1 = compute_correlation_coefficient(anglesL[2], anglesR[1], dataL2R1)
    kappaL2R2 = compute_correlation_coefficient(anglesL[2], anglesR[2], dataL2R2)

    chsh_contrast = -kappaL1R1 + kappaL1R2 + kappaL2R1 + kappaL2R2

    # The nominal value of the CHSH contrast for the chosen polarizer
    # orientations is 2*sqrt(2).
    chsh_contrast_nominal = 2 * sqrt(2.0)

    @printf("\n   light pulse events   %9d\n\n", length(data))
    println("    correlation coefs")
    @printf("              %2d° %2d°   %+9.6f\n", anglesL[1], anglesR[1], kappaL1R1)
    @printf("              %2d° %2d°   %+9.6f\n", anglesL[1], anglesR[2], kappaL1R2)
    @printf("              %2d° %2d°   %+9.6f\n", anglesL[2], anglesR[1], kappaL2R1)
    @printf("              %2d° %2d°   %+9.6f\n\n", anglesL[2], anglesR[2], kappaL2R2)
    @printf("        CHSH contrast   %+9.6f\n", chsh_contrast)
    @printf("  2*sqrt(2) = nominal   %+9.6f\n", chsh_contrast_nominal)
    @printf("           difference   %+9.6f\n", chsh_contrast - chsh_contrast_nominal)

    # A "CHSH violation" occurs if the CHSH contrast is >2.
    # https://en.wikipedia.org/w/index.php?title=CHSH_inequality&oldid=1142431418
    @printf("\n       CHSH violation   %+9.6f\n\n", chsh_contrast - 2)
end

run_analysis("datalog.log")
