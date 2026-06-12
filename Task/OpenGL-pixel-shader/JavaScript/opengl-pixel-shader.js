<html style="margin: 0;">
  <head>
    <title>Fragment Shader WebGL Example</title>
    <!-- This use of <script> elements is so that we can have multiline text
         without quoting it inside of JavaScript; the web browser doesn't
         actually do anything besides store the text of these. -->
    <script id="shader-fs" type="text/x-fragment_shader">
      precision highp float;
      uniform float u_time;
      void main(void) {
        // some gobbledegook
        vec3 foo = vec3(pow(gl_FragCoord.xy, vec2(1.0 + sin(dot(vec4(1.0, 100.0, 0.0, 0.0), gl_FragCoord)))), 0.0);
        foo *= mat3(1.2, 3.9, 1.4, 4.1, 0.2, 1.4, 2.5, 1.6, 7.2);

        gl_FragColor = vec4(mod(foo + vec3(u_time), 1.0), 1.0);
      }
    </script>
    <script id="shader-vs" type="text/x-vertex_shader">
      attribute vec3 a_position;
      attribute vec4 a_color;
      varying vec4 v_color;
      void main(void) {
        gl_Position = vec4(a_position, 1.0);
        v_color = a_color;
      }
    </script>
    <script type="text/javascript">
      function getShader(gl, id) {
        var scriptElement = document.getElementById(id);
        // Create shader object
        var shader;
        shader= gl.createShader(gl[scriptElement.type.replace('text/x-','').toUpperCase()]);
        // Compile shader from source
        gl.shaderSource(shader, scriptElement.textContent);
        gl.compileShader(shader);
        if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS))
          throw new Error(gl.getShaderInfoLog(shader));
        return shader;
      }
    </script>
  </head>
  <body style="margin: 0;">
    <canvas id="glcanvas" style="border: none; margin: auto; display: block;" width="640" height="480"></canvas>
    <script type="text/javascript">
      var canvas = document.getElementById("glcanvas");

      // Get WebGL context.
      var gl = canvas.getContext("webgl")
            || canvas.getContext("experimental-webgl");
      if (!gl)
        throw new Error("WebGL context not found");

      // Create shader program from vertex and fragment shader code.
      var shaderProgram = gl.createProgram();
      gl.attachShader(shaderProgram, getShader(gl, "shader-vs"));
      gl.attachShader(shaderProgram, getShader(gl, "shader-fs"));
      gl.linkProgram(shaderProgram);
      if (!gl.getProgramParameter(shaderProgram, gl.LINK_STATUS))
        throw new Error(gl.getProgramInfoLog(shaderProgram));

      // Specify to render using that program.
      gl.useProgram(shaderProgram);

      // Get the indexes to communicate vertex attributes to the program.
      var positionAttr = gl.getAttribLocation(shaderProgram, "a_position");
      // And specify that we will be actually delivering data to those attributes.
      gl.enableVertexAttribArray(positionAttr);

      var timeUniform = gl.getUniformLocation(shaderProgram, "u_time");

      // Store vertex positions and colors in array buffer objects.
      var vertices;
      var positionBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices = [
        -0.5, -0.5, 0,
        +0.5, -0.5, 0,
        -0.5, +0.5, 0
      ]), gl.STATIC_DRAW);
      var numVertices = vertices.length / 3; // 3 coordinates per vertex

      // Set GL state
      gl.clearColor(0.3, 0.3, 0.3, 1.0);
      gl.enable(gl.DEPTH_TEST);
      gl.viewport(0, 0, gl.drawingBufferWidth || canvas.width,
                        gl.drawingBufferHeight || canvas.height);

      //Specify the array data to render.
      gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
      gl.vertexAttribPointer(positionAttr, 3, gl.FLOAT, false, 0, 0);

      var t0 = Date.now();
      function frame() {
        gl.uniform1f(timeUniform, (Date.now() - t0) / 1000);

        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
        gl.drawArrays(gl.TRIANGLES, 0, numVertices);

        var e;
        while (e = gl.getError())
          console.log("GL error", e);

      }
      setInterval(frame, 1000/20);
    </script>
  </body>
</html>
