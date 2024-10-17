y, t = 1, 0
while t <= 10
   k1	=  t         * Math.sqrt(y)
   k2	= (t + 0.05) * Math.sqrt(y + 0.05 * k1)
   k3	= (t + 0.05) * Math.sqrt(y + 0.05 * k2)
   k4	= (t + 0.1)  * Math.sqrt(y + 0.1  * k3)

   printf("y(%4.1f)\t= %12.6f \t error: %12.6e\n", t, y, (((t**2 + 4)**2 / 16) - y )) if (t.round - t).abs < 1.0e-5
   y += 0.1 * (k1 + 2 * (k2 + k3) + k4) / 6
   t += 0.1
end
