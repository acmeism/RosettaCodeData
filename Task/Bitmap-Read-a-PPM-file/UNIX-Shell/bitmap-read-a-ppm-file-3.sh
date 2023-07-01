Bitmap_t c
c.read "$HOME/tmp/bitmap.ppm"
c.to_s

if [[ $(c.to_s) == $(cat "$HOME/tmp/bitmap.ppm") ]]; then
    echo looks OK
else
    echo something is wrong
fi

c.grayscale
c.to_s
c.write "$HOME/tmp/bitmap_g.ppm"
