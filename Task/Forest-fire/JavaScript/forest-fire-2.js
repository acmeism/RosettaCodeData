var forest = {
    X: 50,
    Y: 50,
    propTree: 0.5,
    propTree2: 0.01,
    propBurn: 0.0001,
    t: [],
    c: ['rgb(255,255,255)', 'rgb(0,255,0)', 'rgb(255,0,0)']
};

for(var i = 0; i < forest.Y; i++) {
    forest.t[i] = [];
    for(var j = 0; j < forest.Y; j++) {
        forest.t[i][j] = Math.random() < forest.propTree ? 1 : 0;
    }
}

function afterLoad(forest) {
    var canvas = document.getElementById('canvas');
    var c = canvas.getContext('2d');
    for(var i = 0; i < forest.X; i++) {
        for(var j = 0; j < forest.Y; j++) {
            c.fillStyle = forest.c[forest.t[i][j]];
            c.fillRect(10*j, 10*i, 10*j+9, 10*i+9);
        }
    }
}

function doStep(forest) {
    var to = [];
    for(var i = 0; i < forest.Y; i++) {
        to[i] = forest.t[i].slice(0);
    }

    //indices outside the array are undefined; which converts to 0=empty on forced typecast
    for(var i = 0; i < forest.Y; i++) {
        for(var j = 0; j < forest.Y; j++) {
            if(0 == to[i][j]) {
                forest.t[i][j] = Math.random() < forest.propTree2 ? 1 : 0;
            } else if(1 == to[i][j]) {
                if(
                    ((i>0) && (2 == to[i-1][j])) ||
                    ((i<forest.Y-1) && (2 == to[i+1][j])) ||
                    ((j>0) && (2 == to[i][j-1])) ||
                    ((j<forest.X-1) && (2 == to[i][j+1]))
                    ) {
                    forest.t[i][j] = 2;
                } else {
                    forest.t[i][j] = Math.random() < forest.propBurn ? 2 : 1;
                }
            } else if(2 == to[i][j]) {
                //If it burns, it gets empty ...
                forest.t[i][j] = 0;
            }
        }
    }

}

window.setInterval(function(){
    doStep(forest);
    afterLoad(forest);
}, 100);
