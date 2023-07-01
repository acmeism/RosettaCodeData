function brownian(canvasId, messageId) {
  var canvas = document.getElementById(canvasId);
  var ctx = canvas.getContext("2d");

  // Options
  var drawPos = true;
  var seedResolution = 50;
  var clearShade = 0; // 0..255

  // Static state
  var width = canvas.width;
  var height = canvas.height;
  var cx = width/2;
  var cy = height/2;
  var clearStyle = "rgba("+clearShade+", "+clearShade+", "+clearShade+", 1)";

  // Utilities
  function radius(x,y) {
    return Math.sqrt((x-cx)*(x-cy)+(y-cx)*(y-cy));
  }
  function test(x, y) {
    if (x < 0 || y < 0 || x >= width || y >= height)
      return false;
    var data = ctx.getImageData(x, y, 1, 1).data;
    return data[0] != clearShade || data[1] != clearShade || data[2] != clearShade;
  }
  var shade = 120;
  function setc(x, y, c) {
    //var imgd = ctx.createImageData(1, 1);
    //var pix = imgd.data;
    //pix[0] = pix[1] = pix[2] = c == 255 ? 255 : shade;
    //pix[3] = 255;
    //shade = (shade + 1) % 254;
    //ctx.putImageData(imgd, x, y);
    //ctx.fillStyle = "rgba("+c+", "+c+", "+c+", 1)";
    shade = (shade + 0.02) % 360;
    if (c) {
      ctx.fillStyle = "hsl("+shade+", 100%, 50%)";
    } else {
      ctx.fillStyle = clearStyle;
    }
    ctx.fillRect (x, y, 1, 1);
  }
  function set(x,y) {
    setc(x,y,true);
  }
  function clear(x,y) {
    setc(x,y,false);
  }

  // Initialize canvas to blank opaque
  ctx.fillStyle = clearStyle;
  ctx.fillRect (0, 0, width, height);

  // Current position
  var x;
  var y;

  // Farthest distance from center a particle has yet been placed.
  var closeRadius = 1;

  // Place seed
  set(cx, cy);

  // Choose a new random position for a particle (not necessarily unoccupied)
  function newpos() {
    // Wherever particles are injected, the tree will tend to grow faster
    // toward it. Ideally, particles wander in from infinity; the best we
    // could do is to have them wander in from the edge of the field.
    // But in order to have the rendering occur in a reasonable time when
    // the seed is small, without too much visible bias, we instead place
    // the particles in a coarse grid. The final tree will cover every
    // point on the grid.
    //
    // There's probably a better strategy than this.
    x = Math.floor(Math.random()*(width/seedResolution))*seedResolution;
    y = Math.floor(Math.random()*(height/seedResolution))*seedResolution;
  }
  newpos();

  var animation;
  animation = window.setInterval(function () {
    if (drawPos) clear(x,y);
    for (var i = 0; i < 10000; i++) {
      var ox = x;
      var oy = y;

      // Changing this to use only the first four directions will result
      // in a denser tree.
      switch (Math.floor(Math.random()*8)) {
        case 0: x++; break;
        case 1: x--; break;
        case 2: y++; break;
        case 3: y--; break;
        case 4: x++; y++; break;
        case 5: x--; y++; break;
        case 6: x++; y--; break;
        case 7: x--; y--; break;
      }
      if (x < 0 || y < 0 ||
          x >= width || y >= height ||
          radius(x,y) > closeRadius+seedResolution+2) {
        // wandered out of bounds or out of interesting range of the
        // tree, so pick a new spot
        var progress = 1000;
        do {
          newpos();
          progress--;
        } while ((test(x-1,y-1) || test(x,y-1) || test(x+1,y-1) ||
                  test(x-1,y  ) || test(x,y  ) || test(x+1,y  ) ||
                  test(x-1,y+1) || test(x,y+1) || test(x+1,y+1)) && progress > 0);
        if (progress <= 0) {
          document.getElementById(messageId).appendChild(
              document.createTextNode("Stopped for lack of room."));
          clearInterval(animation);
          break;
        }
      }
      if (test(x, y)) {
        // hit something, mark where we came from and pick a new spot
        set(ox,oy);
        closeRadius = Math.max(closeRadius, radius(ox,oy));
        newpos();
      }
   }
   if (drawPos) set(x,y);
  }, 1);

}
