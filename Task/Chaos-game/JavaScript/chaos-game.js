<html>

<head>

<meta charset="UTF-8">

<title>Chaos Game</title>

</head>

<body>

<p>
<canvas id="sierpinski" width=400 height=346></canvas>
</p>

<p>
<button onclick="chaosGame()">Click here to see a Sierpiński triangle</button>
</p>

<script>

function chaosGame() {
    var canv = document.getElementById('sierpinski').getContext('2d');
    var x = Math.random() * 400;
    var y = Math.random() * 346;
    for (var i=0; i<30000; i++) {
        var vertex = Math.floor(Math.random() * 3);
        switch(vertex) {
            case 0:
                x = x / 2;
                y = y / 2;
                canv.fillStyle = 'green';
                break;
            case 1:
                x = 200 + (200 - x) / 2
                y = 346 - (346 - y) / 2
                canv.fillStyle = 'red';
                break;
            case 2:
                x = 400 - (400 - x) / 2
                y = y / 2;
                canv.fillStyle = 'blue';
        }
        canv.fillRect(x,y, 1,1);
    }
}

</script>

</body>

</html>
