webgl_close=: {{ wd'pclose'}}
wd {{)n
  pc webgl; cc w webview;
  pmove 0 0 518 518;
  pshow;
  set w html *
<html><head><title>test</title></head>
  <script>
  function paint(t) {
    gl.uniform1f(timeNdx, t/1e3);
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
    requestAnimationFrame(paint);
  }
  function run(){
    c= document.querySelector("#c");
    gl= c.getContext("webgl");
    P= gl.createProgram();
    function setShader(typ, src) {
      shader= gl.createShader(typ);
      gl.shaderSource(shader, src);
      gl.compileShader(shader);
      gl.attachShader(P, shader);
    }
    setShader(gl.VERTEX_SHADER, "attribute vec4 pos;void main(){gl_Position=pos;}")
    setShader(gl.FRAGMENT_SHADER, `
      precision mediump float;
      uniform vec2 res;
      uniform float time;
      mat3 rotateY(float theta) {
          float c= cos(theta);
          float s= sin(theta);
          return mat3(
              vec3(c, 0, s),
              vec3(0, 1, 0),
              vec3(-s, 0, c)
          );
      }
      const float MAX_DIST= 100.0;
      float sdBox(vec3 position, vec3 box, vec3 offset) {
        vec3 q= abs(position - offset) - box/2.0;
        return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
      }
      float sdScene(vec3 p) { // distance to closest object
        float dist=      sdBox(p, vec3(1,4,1),   vec3(0, -0.5, 0));
        dist=  min(dist, sdBox(p, vec3(1.5,1,1), vec3(0.75, -0.5, 0)));
        return min(dist, sdBox(p, vec3(2.5,1,1), vec3(0.75, 1.5, 0)));
      }
      float rayMarch(vec3 ro, vec3 rd, float depth, float end) {
        for (int i= 0; i< 100 /* MAX_MARCHING_STEPS */; i++) {
          if (depth < end) depth+= sdScene(ro + depth * rd);
        }
        return depth;
      }
      vec3 calcNormal(in vec3 p) {
          vec2 e= vec2(1.0, -1.0) * 0.0005; // epsilon
          return normalize(
            e.xyy * sdScene(p + e.xyy) +
            e.yyx * sdScene(p + e.yyx) +
            e.yxy * sdScene(p + e.yxy) +
            e.xxx * sdScene(p + e.xxx));
      }
      void main(){
        vec2 uv= (gl_FragCoord.xy-.5*res)/res.x;
        mat3 rot= rotateY(time);
        vec3 backgroundColor= vec3(0.835, 1, 1);
        vec3 color;
        vec3 ro= vec3(0, 0, 7)*rot; // ray origin that represents camera position
        vec3 rd= normalize(vec3(uv, -1)*rot); // ray direction
        float sd= rayMarch(ro, rd, 0.0 /* MIN_DIST */, MAX_DIST); // closest object
        if (sd > MAX_DIST) {
          color= backgroundColor; // ray didn't hit anything
        } else {
          vec3 p= ro + rd * sd; // point on cube we discovered from ray marching
          vec3 normal= calcNormal(p);
          vec3 lightPosition= vec3(2, 2, 7)*rot;
          vec3 lightDirection= normalize(lightPosition - p);
          float dif= clamp(dot(normal, lightDirection), 0.3, 1.); // diffuse reflection
          color= dif * vec3(1,0,0) + backgroundColor * .2; // Add a bit of background color to the diffuse color
        }
        gl_FragColor= vec4(color, 1.0);
      }
    `); /* end of FRAGMENT_SHADER */
    gl.linkProgram(P);
    posNdx= gl.getAttribLocation(P, "pos");
    timeNdx= gl.getUniformLocation(P, "time");
    posBuffer= gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, posBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1,-1,  -1,1,  1,-1,  1,1]), gl.STATIC_DRAW);
    gl.viewport(0,0,c.width,c.height);
    gl.useProgram(P);
    gl.enableVertexAttribArray(posNdx);
    gl.bindBuffer(gl.ARRAY_BUFFER, posBuffer);
    gl.vertexAttribPointer(posNdx, 2, gl.FLOAT, false, 0, 0);
    gl.uniform2f(gl.getUniformLocation(P, "res"), c.width, c.height);
    requestAnimationFrame(paint);
  }
  </script>
</head><body onload="run()" style="margin: 0">
  <canvas id="c" width=500 height=500></canvas>
</body></html>
}}
