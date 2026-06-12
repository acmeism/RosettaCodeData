var arcLength = Fn.new { |r, angle1, angle2| (360 - (angle2 - angle1).abs) * Num.pi / 180 * r }

System.print(arcLength.call(10, 10, 120))
