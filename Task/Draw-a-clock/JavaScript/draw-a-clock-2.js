<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <style>
        canvas {
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

        // which leds are on or off for each digit
        var masks = ["1110111", "0010010", "1011101", "1011011", "0111010",
            "1101011", "1101111", "1010010", "1111111", "1111011"];

        // horizontal and vertical layouts in scalable units
        var vertices = [
            [
                [0, 0], [1, 1], [7, 1], [8, 0], [7, -1], [1, -1]
            ],
            [
                [0, 0], [-1, 1], [-1, 7], [0, 8], [1, 7], [1, 1]
            ]
        ];

        function Led(x, y, idx, ox, oy) {
            // starting points in scalable units
            this.x = x;
            this.y = y;

            // horizontal or vertical layout
            this.idx = idx;

            // pixel values to create small gaps between the leds
            this.offset_x = ox;
            this.offset_y = oy;
        }

        var leds = [];
        leds.push(new Led(0, 0, 0, 0, -1));
        leds.push(new Led(0, 0, 1, -1, 0));
        leds.push(new Led(8, 0, 1, 1, 0));
        leds.push(new Led(0, 8, 0, 0, 1));
        leds.push(new Led(0, 8, 1, -1, 2));
        leds.push(new Led(8, 8, 1, 1, 2));
        leds.push(new Led(0, 16, 0, 0, 3));

        var onColor, offColor;

        function drawDigitalClock(color1, color2, size) {

            var clockWidth = (6 * 15 + 2 * 10) * size;
            var clockHeight = 20 * size;
            var x = (canvas.width - clockWidth) / 2;
            var y = (canvas.height - clockHeight) / 2;

            onColor = color1;
            offColor = color2;

            g.clearRect(0, 0, canvas.width, canvas.height);

            var date = new Date();
            var segments = [date.getHours(), date.getMinutes(), date.getSeconds()];

            segments.forEach(function (value, index) {
                x = drawDigits(x, y, size, value);
                if (index < 2) {
                    x = drawSeparator(x, y, size);
                }
            });
        }

        function drawDigits(x, y, size, timeUnit) {

            var digit1 = Math.floor(timeUnit / 10);
            var digit2 = timeUnit % 10;

            x = drawLeds(x, y, size, masks[digit1]);
            x = drawLeds(x, y, size, masks[digit2]);

            return x;
        }

        function drawSeparator(x, y, size) {

            g.fillStyle = onColor;
            g.fillRect(x + 0.5 * size, y + 3 * size, 2 * size, 2 * size);
            g.fillRect(x + 0.5 * size, y + 10 * size, 2 * size, 2 * size);

            return x + size * 10;
        }

        function drawLeds(x, y, size, mask) {

            leds.forEach(function (led, i) {

                g.fillStyle = mask[i] == '1' ? onColor : offColor;

                var xx = x + led.x * size + led.offset_x;
                var yy = y + led.y * size + led.offset_y;

                drawLed(xx, yy, size, vertices[led.idx]);
            });

            return x + size * 15;
        }

        function drawLed(x, y, size, vertices) {

            g.beginPath();
            g.moveTo(x, y);

            vertices.forEach(function (vertex) {
                g.lineTo(x + vertex[0] * size, y + vertex[1] * size);
            });

            g.closePath();
            g.fill();
        }

        setInterval(drawDigitalClock, 1000, "#00FF00", "#002200", 12);
    </script>

</body>
</html>
