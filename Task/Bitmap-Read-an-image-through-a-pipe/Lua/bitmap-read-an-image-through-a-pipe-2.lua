local bitmap = Bitmap(0,0)
fp = io.popen("magick Lenna100.jpg ppm:-", "rb")
bitmap:loadPPM(nil, fp)

bitmap:savePPM("Lenna100.ppm") -- just as "proof"
