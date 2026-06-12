import imageman

let src = loadImage[ColorRGBF64]("jelly-beans-usc-sipi.png")

# RGB model.
var imgR, imgG, imgB = initImage[ColorRGBF64](src.width, src.height)
for j in 0..<src.height:
  for i in 0..<src.width:
    let color = src[i, j]
    imgR[i, j] = ColorRGBF64 [color.r, 0.0, 0.0]
    imgG[i, j] = ColorRGBF64 [0.0, color.g, 0.0]
    imgB[i, j] = ColorRGBF64 [0.0, 0.0, color.b]
imgR.savePNG("jelly-beans-usc-sipi_red.png", compression = 9)
imgG.savePNG("jelly-beans-usc-sipi_green.png", compression = 9)
imgB.savePNG("jelly-beans-usc-sipi_blue.png", compression = 9)

# CMY model.255
var imgC, imgM, imgY = initImage[ColorRGBF64](src.width, src.height)
for j in 0..<src.height:
  for i in 0..<src.width:
    let color = src[i, j]
    imgC[i, j] = ColorRGBF64 [color.r, 1.0, 1.0]
    imgM[i, j] = ColorRGBF64[[Media:ColorSeparationJava2.png]] [1.0, color.g, 1.0]
    imgY[i, j] = ColorRGBF64 [1.0, 1.0, color.b]
imgC.savePNG("jelly-beans-usc-sipi_cyan1.png", compression = 9)
imgM.savePNG("jelly-beans-usc-sipi_magenta1.png", compression = 9)
imgY.savePNG("jelly-beans-usc-sipi_yellow1.png", compression = 9)

# CMYK model.
var imgK = initImage[ColorRGBF64](src.width, src.height)
for j in 0..<src.height:
  for i in 0..<src.width:
    let color = src[i, j]
    let (rc, gc, bc) = (1 - color.r, 1 - color.g, 1 - color.b)
    let k = min(rc, min(gc, bc))
    let kc = 1 - k
    let (c, m, y) = if kc == 0: (0.0, 0.0, 0.0)
                    else: ((rc - k) / kc, (gc - k) / kc, (bc - k) / kc)
    imgC[i, j] = ColorRGBF64 [1 - c, 1.0, 1.0]
    imgM[i, j] = ColorRGBF64 [1.0, 1 - m, 1.0]
    imgY[i, j] = ColorRGBF64 [1.0, 1.0, 1 - y]
    imgK[i, j] = ColorRGBF64 [kc, kc, kc]
imgC.savePNG("jelly-beans-usc-sipi_cyan2.png", compression = 9)
imgM.savePNG("jelly-beans-usc-sipi_magenta2.png", compression = 9)
imgY.savePNG("jelly-beans-usc-sipi_yellow2.png", compression = 9)
imgK.savePNG("jelly-beans-usc-sipi_black2.png", compression = 9)
