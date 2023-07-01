function toGray(img) {
  let cnv = document.getElementById("canvas");
  let ctx = cnv.getContext('2d');
  let imgW = img.width;
  let imgH = img.height;
  cnv.width = imgW;
  cnv.height = imgH;

  ctx.drawImage(img, 0, 0);
  let pixels = ctx.getImageData(0, 0, imgW, imgH);
  for (let y = 0; y < pixels.height; y ++) {
    for (let x = 0; x < pixels.width; x ++) {
      let i = (y * 4) * pixels.width + x * 4;
      let avg = (pixels.data[i] + pixels.data[i + 1] + pixels.data[i + 2]) / 3;

      pixels.data[i] = avg;
      pixels.data[i + 1] = avg;
      pixels.data[i + 2] = avg;
    }
  }
  ctx.putImageData(pixels, 0, 0, 0, 0, pixels.width, pixels.height);
  return cnv.toDataURL();
}
