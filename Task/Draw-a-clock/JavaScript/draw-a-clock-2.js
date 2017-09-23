<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        canvas.addEventListener("click", function () {
            colorIndex = (colorIndex + 1) % colors.length;
        });

        var g = canvas.getContext("2d");

        var colors = [
            { on: "#00FF00", off: "#002200" },
            { on: "#FF0000", off: "#220000" },
            { on: "#0000FF", off: "#000033" }
        ];

        var masks = ["1110111", "0010010", "1011101", "1011011", "0111010",
            "1101011", "1101111", "1010010", "1111111", "1111011"];

        // 0, 0 is upper left; these relative units are multiplied by the size value later
        var startingPoints = [
            [0, 0], [0, 0], [8, 0], [0, 8], [0, 8], [8, 8], [0, 16]
        ];

        var isHorizontal = [1, 0, 0, 1, 0, 0, 1]; // bool

        var vertices = [
            [
                // horizontal
                [0, 0], [1, 1], [7, 1], [8, 0], [7, -1], [1, -1]
            ],
            [
                // vertical
                [0, 0], [-1, 1], [-1, 7], [0, 8], [1, 7], [1, 1]
            ]
        ];

        // pixel values, to create small gaps between the elements (leds)
        var offsets = [
            [0, -1], [-1, 0], [1, 0], [0, 1], [-1, 2], [1, 2], [0, 3]
        ]

        var onColor, offColor, colorIndex = 0;

        function drawDigitalClock(x, y, size) {

            onColor = colors[colorIndex].on;
            offColor = colors[colorIndex].off;

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

            x = drawElements(x, y, size, masks[digit1]);
            x = drawElements(x, y, size, masks[digit2]);

            return x;
        }

        function drawSeparator(x, y, size) {

            g.fillStyle = onColor;
            g.fillRect(x + 0.5 * size, y + 3 * size, 2 * size, 2 * size);
            g.fillRect(x + 0.5 * size, y + 10 * size, 2 * size, 2 * size);

            return x + size * 10;
        }

        function drawElements(x, y, size, mask) {

            startingPoints.forEach(function (point, i) {

                g.fillStyle = mask[i] == '1' ? onColor : offColor;

                var xx = x + point[0] * size + offsets[i][0];
                var yy = y + point[1] * size + offsets[i][1];
                var idx = isHorizontal[i] ? 0 : 1;

                drawElement(xx, yy, size, vertices[idx]);
            });

            return x + size * 15;
        }

        function drawElement(x, y, size, vertices) {

            g.beginPath();
            g.moveTo(x, y);

            vertices.forEach(function (vertex) {
                g.lineTo(x + vertex[0] * size, y + vertex[1] * size);
            });

            g.closePath();
            g.fill();
        }

        setInterval(drawDigitalClock, 1000, 140, 200, 12);
    </script>

</body>

</html>
