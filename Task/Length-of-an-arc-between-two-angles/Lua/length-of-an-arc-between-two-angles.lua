function arcLength(radius, angle1, angle2)
    return (360.0 - math.abs(angle2 - angle1)) * math.pi * radius / 180.0
end

function main()
    print("arc length: " .. arcLength(10.0, 10.0, 120.0))
end

main()
