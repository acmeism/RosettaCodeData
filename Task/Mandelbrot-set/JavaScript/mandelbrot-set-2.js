<!DOCTYPE html>
<html>
  <head>
    <title>Mandelbrot set</title>
    <script src="Mandelbrot.js" type="text/javascript"></script>
  </head>

  <body onload="Mandelbrot()">
    <h1>Mandelbrot set</h1>

    <form id="calcdata" onsubmit="javascript:Mandelbrot(); return false;">
      <table>
          <tr>
            <td>xmin =</td>
            <td><input name="xmin" type="text" size="10" value="-2"></td>
            <td>xmax =</td>
            <td><input name="xmax" type="text" size="10" value="1"></td>
          </tr>
          <tr>
            <td>ymin =</td>
            <td><input name="ymin" type="text" size="10" value="-1"></td>
            <td>ymax =</td>
            <td><input name="ymax" type="text" size="10" value="1"></td>
          </tr>
      </table>
      <p>iterations =
        <input name="iterations" type="text" size="10" value="1000"></p>
      <p>
        <input type="submit" value=" Calculate ">
        <input type="reset" value=" Reset form ">
      </p>
    </form>

    <canvas id="mandelimage" width="900" height="600">
      This page needs a browser with canvas support.
    </canvas>
  </body>
</html>
