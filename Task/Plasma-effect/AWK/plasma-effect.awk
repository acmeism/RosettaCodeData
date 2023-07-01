#!/usr/bin/awk -f

function clamp(val, a, b) { return (val<a) ? a : (val>b) ? b : val }

## return a timestamp with centisecond precision
function timex() {
  getline < "/proc/uptime"
  close("/proc/uptime")
  return $1
}

## draw image to terminal
function draw(src, xpos, ypos,    w,h, x,y, up,dn, line,screen) {
  w = src["width"]
  h = src["height"]

  for (y=0; y<h; y+=2) {
    line = sprintf("\033[%0d;%0dH", y/2+ypos+1, xpos+1)
    for (x=0; x<w; x++) {
      up = src[x,y+0]
      dn = src[x,y+1]
      line = line "\033[38;2;" palette[up] ";48;2;" palette[dn] "m▀"
    }
    screen = screen line "\033[0m"
  }
  printf("%s", screen)
}

## generate a palette
function paletteGen(    i, r,g,b) {
  # generate palette
  for (i=0; i<256; i++) {
    r = 128 + 128 * sin(3.14159265 * i / 32.0)
    g = 128 + 128 * sin(3.14159265 * i / 64.0)
    b = 128 + 128 * sin(3.14159265 * i / 128.0)
    palette[i] = sprintf("%d;%d;%d", clamp(r,0,255), clamp(g,0,255), clamp(b,0,255))
  }
}

## generate a plasma
function plasmaGen(plasma, w, h,    x,y, color) {
  for (y=0; y<h; y++) {
    for (x=0; x<w; x++) {
      color = ( \
          128.0 + (128.0 * sin((x / 8.0) - cos(now/2) )) \
        + 128.0 + (128.0 * sin((y / 16.0) - sin(now)*2 )) \
        + 128.0 + (128.0 * sin(sqrt((x - w / 2.0) * (x - w / 2.0) + (y - h / 2.0) * (y - h / 2.0)) / 4.0)) \
        + 128.0 + (128.0 * sin((sqrt(x * x + y * y) / 4.0) - sin(now/4) )) \
      ) / 4;

      plasma[x,y] = int(color)
    }
  }
}

BEGIN {
  "stty size" | getline
  buffer["height"] = h = ($1 ? $1 : 24) * 2
  buffer["width"]  = w = ($2 ? $2 : 80)

  paletteGen()
  start = timex()

  while (elapsed < 30) {
    elapsed = (now = timex()) - start

    plasmaGen(plasma, w, h)

    # copy plasma to buffer
    for (y=0; y<h; y++)
      for (x=0; x<w; x++)
        buffer[x,y] = int(plasma[x,y] + now * 100) % 256

    # draw buffer to terminal
    draw(buffer)
  }

  printf("\n")
}
