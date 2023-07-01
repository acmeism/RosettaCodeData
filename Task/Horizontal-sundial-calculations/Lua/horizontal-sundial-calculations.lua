io.write("Enter latitude       => ")
lat = tonumber(io.read())

io.write("Enter longitude      => ")
lng = tonumber(io.read())

io.write("Enter legal meridian => ")
ref = tonumber(io.read())

print()

slat = math.sin(math.rad(lat))

print(string.format("    sine of latitude:   %.3f", slat))
print(string.format("    diff longitude:     %.3f", lng-ref))
print()
print("Hour, sun hour angle, dial hour line angle from 6am to 6pm")

for h = -6, 6 do
	hra = 15 * h
	hra = hra - (lng - ref)
	hla = math.deg(math.atan(slat * math.tan(math.rad(hra))))
	print(string.format("HR=%3d; HRA=%7.3f; HLA=%7.3f", h, hra, hla))
end
