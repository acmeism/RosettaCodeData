<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <style>
        canvas {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 700px;
            height: 500px;
            margin: -250px 0 0 -350px;
        }
        body {
            background-color: navy;
        }
    </style>
</head>
<body>
    <canvas></canvas>
    <script>
        'use strict';
        var canvas = document.querySelector('canvas');
        canvas.width = 700;
        canvas.height = 500;

        var g = canvas.getContext('2d');

        var plasma = createPlasma(canvas.width, canvas.height);
        var hueShift = 0;

        function createPlasma(w, h) {
            var buffer = new Array(h);

            for (var y = 0; y < h; y++) {
                buffer[y] = new Array(w);

                for (var x = 0; x < w; x++) {

                    var value = Math.sin(x / 16.0);
                    value += Math.sin(y / 8.0);
                    value += Math.sin((x + y) / 16.0);
                    value += Math.sin(Math.sqrt(x * x + y * y) / 8.0);
                    value += 4; // shift range from -4 .. 4 to 0 .. 8
                    value /= 8; // bring range down to 0 .. 1

                    buffer[y][x] = value;
                }
            }
            return buffer;
        }

        function drawPlasma(w, h) {
            var img = g.getImageData(0, 0, w, h);

            for (var y = 0; y < h; y++) {

                for (var x = 0; x < w; x++) {

                    var hue = hueShift + plasma[y][x] % 1;
                    var rgb = HSVtoRGB(hue, 1, 1);
                    var pos = (y * w + x) * 4;
                    img.data[pos] = rgb.r;
                    img.data[pos + 1] = rgb.g;
                    img.data[pos + 2] = rgb.b;
                }
            }
            g.putImageData(img, 0, 0);
        }

        /* copied from stackoverflow */
        function HSVtoRGB(h, s, v) {
            var r, g, b, i, f, p, q, t;

            i = Math.floor(h * 6);
            f = h * 6 - i;
            p = v * (1 - s);
            q = v * (1 - f * s);
            t = v * (1 - (1 - f) * s);
            switch (i % 6) {
                case 0: r = v, g = t, b = p; break;
                case 1: r = q, g = v, b = p; break;
                case 2: r = p, g = v, b = t; break;
                case 3: r = p, g = q, b = v; break;
                case 4: r = t, g = p, b = v; break;
                case 5: r = v, g = p, b = q; break;
            }
            return {
                r: Math.round(r * 255),
                g: Math.round(g * 255),
                b: Math.round(b * 255)
            };
        }

        function drawBorder() {
            g.strokeStyle = "white";
            g.lineWidth = 10;
            g.strokeRect(0, 0, canvas.width, canvas.height);
        }

        function animate(lastFrameTime) {
            var time = new Date().getTime();
            var delay = 42;

            if (lastFrameTime + delay < time) {
                hueShift = (hueShift + 0.02) % 1;
                drawPlasma(canvas.width, canvas.height);
                drawBorder();
                lastFrameTime = time;
            }

            requestAnimationFrame(function () {
                animate(lastFrameTime);
            });
        }

        g.fillRect(0, 0, canvas.width, canvas.height);
        animate(0);
    </script>

</body>
</html>
