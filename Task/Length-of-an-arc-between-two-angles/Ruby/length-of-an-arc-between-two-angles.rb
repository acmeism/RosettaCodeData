def arc_length(radius, angle1, angle2)
    return (360.0 - (angle2 - angle1).abs) * Math::PI / 180.0 * radius
end

print "%.7f\n" % [arc_length(10, 10, 120)]
