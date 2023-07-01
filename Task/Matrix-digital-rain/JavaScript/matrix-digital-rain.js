var tileSize = 20;
// a higher fade factor will make the characters fade quicker
var fadeFactor = 0.05;

var canvas;
var ctx;

var columns = [];
var maxStackHeight;

function init() {
	canvas = document.getElementById('canvas');
	ctx = canvas.getContext('2d');

    // https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver
    const resizeObserver = new ResizeObserver(entries =>
    {
        for (let entry of entries)
        {
            if (entry.contentBoxSize)
            {
                // Firefox implements `contentBoxSize` as a single content rect, rather than an array
                const contentBoxSize = Array.isArray(entry.contentBoxSize) ? entry.contentBoxSize[0] : entry.contentBoxSize;

                canvas.width = contentBoxSize.inlineSize;
                canvas.height = window.innerHeight;

                initMatrix();
            }
        }
    });

    // observe the size of the document
    resizeObserver.observe(document.documentElement);

	// start the main loop
	tick();
}

function initMatrix() {
    columns = [];

    maxStackHeight = Math.ceil(canvas.height/tileSize);

    // divide the canvas into columns
    for (let i = 0 ; i < canvas.width/tileSize ; ++i) {
        var column = {};
        // save the x position of the column
        column.x = i*tileSize;
        // create a random stack height for the column
        column.stackHeight = 10+Math.random()*maxStackHeight;
        // add a counter to count the stack height
        column.stackCounter = 0;
        // add the column to the list
        columns.push(column);
    }
}

function draw() {
    // draw a semi transparent black rectangle on top of the scene to slowly fade older characters
    ctx.fillStyle = "rgba(0 , 0 , 0 , "+fadeFactor+")";
    ctx.fillRect(0 , 0 , canvas.width , canvas.height);

    ctx.font = (tileSize-2)+"px monospace";
    ctx.fillStyle = "rgb(0 , 255 , 0)";
    for (let i = 0 ; i < columns.length ; ++i) {
        // pick a random ascii character (change the 94 to a higher number to include more characters)
        var randomCharacter = String.fromCharCode(33+Math.floor(Math.random()*94));
        ctx.fillText(randomCharacter , columns[i].x , columns[i].stackCounter*tileSize+tileSize);

        // if the stack is at its height limit, pick a new random height and reset the counter
        if (++columns[i].stackCounter >= columns[i].stackHeight)
        {
            columns[i].stackHeight = 10+Math.random()*maxStackHeight;
            columns[i].stackCounter = 0;
        }
    }
}

// MAIN LOOP
function tick() {	
    draw();
    setTimeout(tick , 50);
}

var b_isFullscreen = false;

function fullscreen() {
    var elem = document.documentElement;
    if (elem.requestFullscreen) {
        elem.requestFullscreen();
    }
    else if (elem.webkitRequestFullscreen) {
        elem.webkitRequestFullscreen(); // Safari
    }
    else if (elem.msRequestFullscreen) {
        elem.msRequestFullscreen(); // IE11
    }
}

function exitFullscreen() {
    if (document.exitFullscreen) {
        document.exitFullscreen();
    }
    else if (document.webkitExitFullscreen) {
        document.webkitExitFullscreen(); // Safari
    }
    else if (document.msExitFullscreen) {
        document.msExitFullscreen(); // IE11
    }
}

function toggleFullscreen() {
    if (!b_isFullscreen) {
        fullscreen();
        b_isFullscreen = true;
    }
    else {
        exitFullscreen();
        b_isFullscreen = false;
    }
}

function updateTileSize() {
    tileSize = Math.min(Math.max(document.getElementById("tileSize").value , 10) , 100);
    initMatrix();
}

function updateFadeFactor() {
    fadeFactor = Math.min(Math.max(document.getElementById("fadeFactor").value , 0.0) , 1.0);
    initMatrix();
}
