declare
  [BitmapIO Grayscale] = {Module.link ['BitmapIO.ozf' 'Grayscale.ozf']}

  B = {BitmapIO.read "image.ppm"}
  G = {Grayscale.toGraymap B}
in
  {BitmapIO.write {Grayscale.fromGraymap G} "greyimage.ppm"}
