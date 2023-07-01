<!DOCTYPE html>
<meta charset="utf-8" />
<title>Clock</title>
<script language="javascript" type="text/javascript">

  var connurl = "ws://{{.Host}}:{{.Port}}/ws";
  //var ctx;
  var secondhand;
  var minutehand;
  var hourhand;
  function wsConnect()
  {
	//get contexts for drawing
    //var canvas = document.getElementById( "canvas" );
    //ctx = canvas.getContext( '2d' );
	var canvas = document.getElementById("rim");
    //draw circle for rim
    rim =  canvas.getContext('2d');
    rim.beginPath();
    rim.arc(256,256,256,0,2*Math.PI);
    rim.stroke();
    //minute hand
    canvas = document.getElementById("minutehand");
    minutehand = canvas.getContext('2d');
    //hour hand
    canvas = document.getElementById("hourhand");
    hourhand = canvas.getContext('2d');
    //second hand
    canvas = document.getElementById("secondhand");
    secondhand = canvas.getContext('2d');

    ws = new WebSocket( connurl );
    ws.onopen = function( e ) {
      console.log( "CONNECTED" );
      ws.send( "READY" );
    };
    /*ws.onclose = function( e ) {
      console.log( "DISCONNECTED" );
    };*/
    ws.onmessage = function( e ) {
      var data = e.data.split("\n");
      for ( var line in data ) {
        var msg = data[line].split(" ");
        var cmd = msg[0];
        if (cmd =="CLEAR"){
          minutehand.clearRect(0,0,512,512);
          secondhand.clearRect(0,0,512,512);
          hourhand.clearRect(0,0,512,512);
        }else if (cmd === "HOUR"){
          renderline(hourhand, msg);
        }else if (cmd === "MIN"){
          renderline(minutehand, msg);
        }else if (cmd === "SEC"){
          renderline(secondhand, msg);
        }else if (cmd ===""){
          cmd = "";
        }else{
          console.log("BAD COMMAND: "+cmd + "; "+msg);
        }
      }
    };
    ws.onerror = function( e ) {
      console.log( 'WS Error: ' + e.data );
    };
  }
  //render line given paramets
  function renderline(ctx, msg){
    ctx.clearRect(0,0,512,512);
    ctx.width = ctx.width;
    var x = parseInt(msg[1],10);
    var y = parseInt(msg[2],10);
    var color = msg[3];
    ctx.strokeStyle = color;
    ctx.beginPath();
    ctx.moveTo(256,256);
    ctx.lineTo(x,y);
    ctx.stroke();
  }

  window.addEventListener( "load", wsConnect, false );

</script>

<body>
    <h2>Clock</h2>
	
  <canvas id="rim" width="512" height="512" style="position: absolute; left: 0; top: 0; z-index: 0;">
        Sorry, your browser does not support Canvas
  </canvas>
	<canvas id="hourhand" width="512" height="512"style="position: absolute; left: 0; top: 0; z-index: 1;">
        Sorry, your browser does not support Canvas
  </canvas>
	<canvas id="minutehand" width="512" height="512"style="position: absolute; left: 0; top: 0; z-index: 2;">
        Sorry, your browser does not support Canvas
  </canvas>
	<canvas id="secondhand" width="512" height="512"style="position: absolute; left: 0; top: 0; z-index: 3;">
        Sorry, your browser does not support Canvas
  </canvas>
	
</body>
</html>
