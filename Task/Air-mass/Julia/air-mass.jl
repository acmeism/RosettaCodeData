using Printf

const DEG = 0.017453292519943295769236907684886127134  # degrees to radians
const RE = 6371000                                     # Earth radius in meters
const dd = 0.001      # integrate in this fraction of the distance already covered
const FIN = 10000000  # integrate only to a height of 10000km, effectively infinity

""" the density of air as a function of height above sea level """
rho(a::Float64)::Float64 = exp(-a / 8500.0)

""" a = altitude of observer
    z = zenith angle (in degrees)
    d = distance along line of sight """
height(a, z, d) = sqrt((RE + a)^2 + d^2 - 2 * d * (RE + a) * cosd(180 - z)) - RE

""" integrates density along the line of sight """
function column_density(a, z)
    dsum, d = 0.0, 0.0
    while d < FIN
        delta = max(dd, (dd)*d)  # adaptive step size to avoid it taking forever:
        dsum += rho(height(a, z, d + 0.5 * delta)) * delta
        d += delta
    end
    return dsum
end

airmass(a, z) = column_density(a, z) / column_density(a, 0)

println("Angle           0 m          13700 m\n", "-"^36)
for z in 0:5:90
    @printf("%2d      %11.8f      %11.8f\n", z, airmass(0, z), airmass(13700, z))
end
