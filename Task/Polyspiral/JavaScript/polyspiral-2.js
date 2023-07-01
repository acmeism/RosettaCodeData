<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <style>
        body {
            background-color: black;
        }
    </style>
</head>
<body>
    <canvas></canvas>
    <script>
        var canvas = document.querySelector("canvas");
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;

        var g = canvas.getContext("2d");

        var inc = 0;

        function drawSpiral(len, angleIncrement) {
            var x1 = canvas.width / 2;
            var y1 = canvas.height / 2;
            var angle = angleIncrement;

            for (var i = 0; i < 150; i++) {

                var x2 = x1 + Math.cos(angle) * len;
                var y2 = y1 - Math.sin(angle) * len;

                g.strokeStyle = HSVtoRGB(i / 150, 1.0, 1.0);
                g.beginPath();
                g.moveTo(x1, y1);
                g.lineTo(x2, y2);
                g.stroke();

                x1 = x2;
                y1 = y2;

                len += 3;

                angle = (angle + angleIncrement) % (Math.PI * 2);
            }
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
            return "rgb("
                + Math.round(r * 255) + ","
                + Math.round(g * 255) + ","
                + Math.round(b * 255) + ")";
        }

        function toRadians(degrees) {
            return degrees * (Math.PI / 180);
        }

        setInterval(function () {
            inc = (inc + 0.05) % 360;
            g.clearRect(0, 0, canvas.width, canvas.height);
            drawSpiral(5, toRadians(inc));
        }, 40);
    </script>

</body>
</html>
