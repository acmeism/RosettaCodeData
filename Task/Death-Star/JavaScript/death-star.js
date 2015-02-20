<!DOCTYPE html>
<html>
<body style="margin:0">
  <canvas id="myCanvas" width="250" height="250" style="border:1px solid #d3d3d3;">
    Your browser does not support the HTML5 canvas tag.
  </canvas>
  <script>
    var c = document.getElementById("myCanvas");
    var ctx = c.getContext("2d");
    //Fill the canvas with a dark gray background
    ctx.fillStyle = "#222222";
    ctx.fillRect(0,0,250,250);

    // Create radial gradient for large base circle
    var grd = ctx.createRadialGradient(225,175,190,225,150,130);
    grd.addColorStop(0,"#EEEEEE");
    grd.addColorStop(1,"black");
    //Apply gradient and fill circle
    ctx.fillStyle = grd;
    ctx.beginPath();
    ctx.arc(125,125,105,0,2*Math.PI);
    ctx.fill();

    // Create linear gradient for small inner circle
    var grd = ctx.createLinearGradient(75,90,102,90);
    grd.addColorStop(0,"black");
    grd.addColorStop(1,"gray");
    //Apply gradient and fill circle
    ctx.fillStyle = grd;
    ctx.beginPath();
    ctx.arc(90,90,30,0,2*Math.PI);
    ctx.fill();

    //Add another small circle on top of the previous one to enhance the "shadow"
    ctx.fillStyle = "black";
    ctx.beginPath();
    ctx.arc(80,90,17,0,2*Math.PI);
    ctx.fill();
  </script>
</body>
</html>
