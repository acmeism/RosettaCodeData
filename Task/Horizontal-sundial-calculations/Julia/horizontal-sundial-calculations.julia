print("Enter latitude       => ")
lat = parse(Float64, readline(STDIN))
print("Enter longitude      => ")
lng = parse(Float64, readline(STDIN))
print("Enter legal meridian => ")
ref = parse(Float64, readline(STDIN))
println()

slat = sin(deg2rad(lat))
@printf "    sine of latitude:   %.3f\n" slat
@printf "    diff longitude:     %.3f\n" (lng - ref)

println("\nHour, sun hour angle, dial hour line angle from 6am to 6pm\n")

for h in -6:6
  hra = 15 * h
  hra -= lng - ref
  hla = rad2deg(atan(slat * tan(deg2rad(hra))))
  @printf "HR = %3d; HRA = %7.3f; HLA = %7.3f\n" h hra hla
end
