proc hsb2rgb hue sat bri &r &g &b .
   h = (hue - floor hue) * 6
   f = h - floor h
   p = bri * (1 - sat)
   q = bri * (1 - sat * f)
   t = bri * (1 - sat * (1 - f))
   h = floor h
   if h = 0
      r = bri ; g = t ; b = p
   elif h = 1
      r = q ; g = bri ; b = p
   elif h = 2
      r = p ; g = bri ; b = t
   elif h = 3
      r = p ; g = q ; b = bri
   elif h = 4
      r = t ; g = p ; b = bri
   else
      r = bri ; g = p ; b = q
   .
.
proc cwheel .
   for y = 0 to 499
      dy = y - 250
      for x = 0 to 499
         dx = x - 250
         dist = sqrt (dx * dx + dy * dy)
         if dist <= 250
            theta = atan2 dy dx
            hue = (theta + 180) / 360
            hsb2rgb hue (dist / 250) 1 r g b
            gcolor3 r g b
            grect x / 5 y / 5 0.3 0.3
         .
      .
   .
.
cwheel
