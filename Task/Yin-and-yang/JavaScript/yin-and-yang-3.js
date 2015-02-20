<!DOCTYPE html>
<html>

<head>

  <body>
    <svg
    id="svg"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="1.1"
    width="100%"
    height="100%">
      </svg>
      <script>
function makeElem(elemName, attribs) { //atribs must be an Object
  var e = document.createElementNS("http://www.w3.org/2000/svg", elemName),
    a, b, d = attribs.style;
  for (a in attribs) {
    if (attribs.hasOwnProperty(a)) {

      if (a == 'style') {
        for (b in d) {
          if (d.hasOwnProperty(b)) {
            e.style[b] = d[b];
          }
        }
        continue;
      }
      e.setAttributeNS(null, a, attribs[a]);
    }
  }
  return e;
}
var svg = document.getElementById("svg");

function drawYingYang(n, x, y) {
  var d = n / 10;
  h = d * 5, q = h / 2, t = q * 3;
  //A white circle, for the bulk of the left-hand part
  svg.appendChild(makeElem("circle", {
    cx: h,
    cy: h,
    r: h,
    fill: "white"
  }));
  //A black semicircle, for the bulk of the right-hand part
  svg.appendChild(makeElem("path", {
    d: "M " + (h + x) + "," + y + " A " + q + "," + q + " -" + d * 3 + " 0,1 " + (h + x) + "," + (n + y) + " z",
    fill: "black"
  }));
  //Circles to extend each part
  svg.appendChild(makeElem("circle", {
    cx: h + x,
    cy: q + y,
    r: q,
    fill: "white"
  }));
  svg.appendChild(makeElem("circle", {
    cx: h + x,
    cy: t + y,
    r: q,
    fill: "black"
  }));
  //The spots
  svg.appendChild(makeElem("circle", {
    cx: h + x,
    cy: q + y,
    r: d,
    fill: "black"
  }));
  svg.appendChild(makeElem("circle", {
    cx: h + x,
    cy: t + y,
    r: q,
    fill: "black"
  }));
  svg.appendChild(makeElem("circle", {
    cx: h + x,
    cy: t + y,
    r: d,
    fill: "white"
  }));
  //An outline for the whole shape
  svg.appendChild(makeElem("circle", {
    cx: h + x,
    cy: h + y,
    r: h,
    fill: "none",
    stroke: "gray",
    "stroke-width": d / 3
  }));
  if (svg.height.baseVal.valueInSpecifiedUnits < n) {
    svg.setAttributeNS(null, "height", y * 1.25 + n + "px")
  }
  //svg.appendChild(makeElem("circle",{cx:"100", cy:h, r:"40", stroke:"black", "stroke-width":"2", fill:"red"}))
}
drawYingYang(100, 30, 30);
drawYingYang(1000, 200, 200);
      </script>
  </body>
</head>

</html>
