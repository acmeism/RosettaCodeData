YinYang = (function () {
  var scale_x = 2,
    scale_y = 1,
    black = "#",
    white = ".",
    clear = " ",
    out = "";

  function draw(radius) {
    function inCircle(centre_x, centre_y, radius, x, y) {
      return Math.pow(x - centre_x, 2) + Math.pow(y - centre_y, 2) <= Math.pow(radius, 2)
    }
    var bigCircle = function (x, y) {
      return inCircle(0, 0, radius, x, y)
    }, whiteSemiCircle = function (x, y) {
        return inCircle(0, radius / 2, radius / 2, x, y)
      }, smallBlackCircle = function (x, y) {
        return inCircle(0, radius / 2, radius / 6, x, y)
      }, blackSemiCircle = function (x, y) {
        return inCircle(0, -radius / 2, radius / 2, x, y)
      }, smallWhiteCircle = function (x, y) {
        return inCircle(0, -radius / 2, radius / 6, x, y)
      };
    i = 0
    for (var sy = Math.round(radius * scale_y); sy >= -Math.round(radius * scale_y); sy--) {
      //console.log(sy)
      for (var sx = -Math.round(radius * scale_x); sx <= Math.round(radius * scale_x); sx++) {

        var x = sx / scale_x,
          y = sy / scale_y;
        //out+=sx
        //console.log(sx,bigCircle(x,y))
        if (bigCircle(x, y)) {
          //out+="";
          if (whiteSemiCircle(x, y)) {
            //console.log(x,y)
            if (smallBlackCircle(x, y)) {
              out += black
            } else {
              out += white
            }
          } else if (blackSemiCircle(x, y)) {
            if (smallWhiteCircle(x, y)) {
              out += white
            } else {
              out += black
            }
          } else if (x < 0) {
            out += white
          } else {
            out += black
          }

        } else {
          out += clear;
        }

      }
      out += "\n";
    }
    return out;
  }
  return draw
})()
console.log(YinYang(17))
console.log(YinYang(8))
