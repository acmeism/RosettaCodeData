bitmap = Bitmap(0, 0)
bitmap:loadPPM("unfilledcirc.ppm")
bitmap:floodfill( 1, 1, { 255,0,0 }) -- fill exterior (except bottom right) with red
bitmap:floodfill( 50, 50, { 0,255,0 })-- fill larger circle with green
bitmap:floodfill( 100, 100, { 0,0,255 })-- fill smaller circle with blue
bitmap:savePPM("filledcirc.ppm")
