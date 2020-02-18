using Printf

function degree2compasspoint(d::Float64)
    majors = ("north", "east", "south", "west", "north", "east", "south", "west")
    quarter1 = ("N", "N by E", "N-NE", "NE by N", "NE", "NE by E", "E-NE", "E by N")
    quarter2 = map(p -> replace(p, "NE" => "EN"), quarter1)

    d = d % 360 + 360 / 64
    imajor, minor = divrem(d, 90)
    iminor = div(minor * 4, 45)
    imajor += 1
    iminor += 1
    p1, p2 = majors[imajor:imajor+1]
    q = p1 in ("north", "south") ? quarter1 : quarter2
    titlecase(replace(replace(q[iminor], 'N' => p1), 'E' => p2))
end

for i in 0:32
    d = i * 11.25
    i % 3 == 1 && (d += 5.62)
    i % 3 == 2 && (d -= 5.62)
    @printf("%2i %-17s %10.2f°\n", i % 32 + 1, degree2compasspoint(d), d)
end
