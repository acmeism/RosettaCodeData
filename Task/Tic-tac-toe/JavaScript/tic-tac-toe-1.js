<!DOCTYPE html>

<html>

<head>
    <meta charset="utf-8" />
    <title>TicTacToe</title>
</head>

<body>
    <canvas id="canvas" width="400" height="400"></canvas>

    <script>
        //All helper functions
        isBetween = (num, a, b) => {
            return num >= a && num <= b;
        }

        randInt = (low, high) => {
            return Math.floor(Math.random() * (high - low + 1)) + low;
        }

        choice = arr => {
            return arr[randInt(0, arr.length - 1)];
        }

        //Checks if every value in an array equals an item
        equals = (arr, item) => {
            return arr.filter(a => {
                return a === item;
            }).length === arr.length;
        }

        //Returns number of items in array that equal an item
        equallen = (arr, item) => {
            return arr.filter(a => {
                return a === item;
            }).length
        }

        //Checks if any value in the array equals an item
        equalanyof = (arr, item) => {
            return equallen(arr, item) > 0;
        }

        //Should be scalable, but it uses default elements for calculations and tracking
        let canvas = document.getElementById("canvas");
        let ctx = canvas.getContext("2d");
        const width = canvas.width;
        const blockSize = canvas.width / 3;
        const lineSize = blockSize / 5;

        //Draws background
        ctx.fillStyle = "rgb(225, 225, 225)";
        ctx.fillRect(0, 0, 400, 400);

        //Title page
        ctx.fillStyle = "rgb(0, 0, 0)";
        ctx.font = width / (250 / 17) + "px Arial"; //34
        ctx.textAlign = "center";
        ctx.fillText("Tic Tac Toe", width / 2, width / (2 + 2 / 3)); //200, 150

        //Button for starting
        ctx.fillStyle = "rgb(200, 200, 200)";
        ctx.fillRect(width / 3.2, width / 2, width / (2 + 2 / 3), width / 8); //125, 200, 150, 50
        ctx.fillStyle = "rgb(0, 0, 0)";
        ctx.font = width / (200 / 9) + "px Arial"; //18
        ctx.fillText("Start", width / 2, width / (40 / 23)); //200, 230

        //Uses an array so a forEach loop can scan it for the correct tile
        let tileArray = []; //Contains all tiles
        let available = []; //Contains only available tiles

        class Tile {
            constructor(x, y) {
                this.x = x * blockSize;
                this.y = y * blockSize;
                this.state = "none";
                tileArray.push(this);
                available.push(this);
            }

            draw() {
                ctx.strokeStyle = "rgb(175, 175, 175)";
                ctx.lineWidth = blockSize / 10;

                if (this.state === "X") {
                    ctx.beginPath();
                    ctx.moveTo(this.x + blockSize / 4, this.y + blockSize / 4);
                    ctx.lineTo(this.x + blockSize / (4 / 3), this.y + blockSize / (4 / 3));
                    ctx.moveTo(this.x + blockSize / 4, this.y + blockSize / (4 / 3));
                    ctx.lineTo(this.x + blockSize / (4 / 3), this.y + blockSize / 4);
                    ctx.stroke();
                } else if (this.state === "O") {
                    ctx.beginPath();
                    ctx.arc(this.x + blockSize / 2, this.y + blockSize / 2, blockSize / 4, 0, 2 * Math.PI);
                    ctx.stroke();
                }

                //Removes this from the available array
                const ind = available.indexOf(this);
                available = available.slice(0, ind).concat(available.slice(ind + 1, available.length));
            }
        }


        //Defines the game
        let game = {
            state: "start",
            turn: "Player",
            player: "X",
            opp: "O"
        }

        //Generates tiles
        for (let x = 0; x < 3; x++) {
            for (let y = 0; y < 3; y++) {
                new Tile(x, y);
            }
        }

        //Gets the mouse position
        getMousePos = evt => {
            let rect = canvas.getBoundingClientRect();
            return {
                x: evt.clientX - rect.left,
                y: evt.clientY - rect.top
            }
        }

        //Checks for win conditions
        checkCondition = () => {
            //Local variables are created to make access easier
            let as = tileArray[0].state;
            let bs = tileArray[1].state;
            let cs = tileArray[2].state;
            let ds = tileArray[3].state;
            let es = tileArray[4].state;
            let fs = tileArray[5].state;
            let gs = tileArray[6].state;
            let hs = tileArray[7].state;
            let is = tileArray[8].state;

            //Equals function checks if each value in the array has a state of X or O
            if (equals([as, bs, cs], "X") || equals([ds, es, fs], "X") || equals([gs, hs, is], "X") ||
                equals([as, ds, gs], "X") || equals([bs, es, hs], "X") || equals([cs, fs, is], "X") ||
                equals([as, es, is], "X") || equals([cs, es, gs], "X")) {
                alert("Player wins!");
                game.state = "over";
            } else if (equals([as, bs, cs], "O") || equals([ds, es, fs], "O") || equals([gs, hs, is], "O") ||
                equals([as, ds, gs], "O") || equals([bs, es, hs], "O") || equals([cs, fs, is], "O") ||
                equals([as, es, is], "O") || equals([cs, es, gs], "O")) {
                alert("Opponent wins!");
                game.state = "over";
                //It is a tie if none of the above conditions are fulfilled and there are no available tiles
            } else if (available.length === 0) {
                alert("It's a tie!");
                game.state = "over";
            }
        }

        //Controls the opponent. Uses many nested switches/if-else for efficiency
        oppTurn = () => {
            if (game.state === "game") {
                let tile = 0;

                //Similar local variables as the win checker
                let at = tileArray[0].state;
                let bt = tileArray[1].state;
                let ct = tileArray[2].state;
                let dt = tileArray[3].state;
                let et = tileArray[4].state;
                let ft = tileArray[5].state;
                let gt = tileArray[6].state;
                let ht = tileArray[7].state;
                let it = tileArray[8].state;
                let all = [at, bt, ct, dt, et, ft, gt, ht, it];

                /*The AI will automatically win if possible
                I considered using a filter based system, but it was ugly and
                inelegant, and also redundant
                I used a nested if-else instead
                Equallen checks how many values in the array equal the given value*/
                if (equallen(all, "O") >= 2) {
                    if (equallen([at, bt, ct], "O") === 2 && equallen([at, bt, ct], "X") === 0) {
                        if (at === "none") {
                            tile = tileArray[0];
                        } else if (bt === "none") {
                            tile = tileArray[1];
                        } else if (ct === "none") {
                            tile = tileArray[2];
                        }
                    } else if (equallen([dt, et, ft], "O") === 2 && equallen([dt, et, ft], "X") === 0) {
                        if (dt === "none") {
                            tile = tileArray[3];
                        } else if (et === "none") {
                            tile = tileArray[4];
                        } else if (ft === "none") {
                            tile = tileArray[5];
                        }
                    } else if (equallen([gt, ht, it], "O") === 2 && equallen([gt, ht, it], "X") === 0) {
                        if (gt === "none") {
                            tile = tileArray[6];
                        } else if (ht === "none") {
                            tile = tileArray[7];
                        } else if (it === "none") {
                            tile = tileArray[8];
                        }
                    } else if (equallen([at, dt, gt], "O") === 2 && equallen([at, dt, gt], "X") === 0) {
                        if (at === "none") {
                            tile = tileArray[0];
                        } else if (dt === "none") {
                            tile = tileArray[3];
                        } else if (gt === "none") {
                            tile = tileArray[6];
                        }
                    } else if (equallen([bt, et, ht], "O") === 2 && equallen([bt, et, ht], "X") === 0) {
                        if (bt === "none") {
                            tile = tileArray[1];
                        } else if (et === "none") {
                            tile = tileArray[4];
                        } else if (ht === "none") {
                            tile = tileArray[7];
                        }
                    } else if (equallen([ct, ft, it], "O") === 2 && equallen([ct, ft, it], "X") === 0) {
                        if (ct === "none") {
                            tile = tileArray[2];
                        } else if (ft === "none") {
                            tile = tileArray[5];
                        } else if (it === "none") {
                            tile = tileArray[8];
                        }
                    } else if (equallen([at, et, it], "O") === 2 && equallen([at, et, it], "X") === 0) {
                        if (at === "none") {
                            tile = tileArray[0];
                        } else if (et === "none") {
                            tile = tileArray[4];
                        } else if (it === "none") {
                            tile = tileArray[8];
                        }
                    } else if (equallen([ct, et, gt], "O") === 2 && equallen([ct, et, gt], "X") === 0) {
                        if (ct === "none") {
                            tile = tileArray[2];
                        } else if (et === "none") {
                            tile = tileArray[4];
                        } else if (gt === "none") {
                            tile = tileArray[6];
                        }
                    }
                }

                //Stops player from winning if possible
                if (equallen(all, "X") >= 2 && tile === 0) {
                    if (equallen([at, bt, ct], "X") === 2 && equallen([at, bt, ct], "O") === 0) {
                        if (at === "none") {
                            tile = tileArray[0];
                        } else if (bt === "none") {
                            tile = tileArray[1];
                        } else if (ct === "none") {
                            tile = tileArray[2];
                        }
                    } else if (equallen([dt, et, ft], "X") === 2 && equallen([dt, et, ft], "O") === 0) {
                        if (dt === "none") {
                            tile = tileArray[3];
                        } else if (et === "none") {
                            tile = tileArray[4];
                        } else if (ft === "none") {
                            tile = tileArray[5];
                        }
                    } else if (equallen([gt, ht, it], "X") === 2 && equallen([gt, ht, it], "O") === 0) {
                        if (gt === "none") {
                            tile = tileArray[6];
                        } else if (ht === "none") {
                            tile = tileArray[7];
                        } else if (it === "none") {
                            tile = tileArray[8];
                        }
                    } else if (equallen([at, dt, gt], "X") === 2 && equallen([at, dt, gt], "O") === 0) {
                        if (at === "none") {
                            tile = tileArray[0];
                        } else if (dt === "none") {
                            tile = tileArray[3];
                        } else if (gt === "none") {
                            tile = tileArray[6];
                        }
                    } else if (equallen([bt, et, ht], "X") === 2 && equallen([bt, et, ht], "O") === 0) {
                        if (bt === "none") {
                            tile = tileArray[1];
                        } else if (et === "none") {
                            tile = tileArray[4];
                        } else if (ht === "none") {
                            tile = tileArray[7];
                        }
                    } else if (equallen([ct, ft, it], "X") === 2 && equallen([ct, ft, it], "O") === 0) {
                        if (ct === "none") {
                            tile = tileArray[2];
                        } else if (ft === "none") {
                            tile = tileArray[5];
                        } else if (it === "none") {
                            tile = tileArray[8];
                        }
                    } else if (equallen([at, et, it], "X") === 2 && equallen([at, et, it], "O") === 0) {
                        if (at === "none") {
                            tile = tileArray[0];
                        } else if (et === "none") {
                            tile = tileArray[4];
                        } else if (it === "none") {
                            tile = tileArray[8];
                        }
                    } else if (equallen([ct, et, gt], "X") === 2 && equallen([ct, et, gt], "O") === 0) {
                        if (ct === "none") {
                            tile = tileArray[2];
                        } else if (et === "none") {
                            tile = tileArray[4];
                        } else if (gt === "none") {
                            tile = tileArray[6];
                        }
                    }
                }

                //Other options in case the above are not fulfilled
                //Controls the course of play over the game
                if (tile === 0) {
                    switch (9 - available.length) {
                        case 1:
                            //If the center is taken, it plays randomly in the corner
                            //Otherwise, it takes the center
                            if (et === "X") {
                                tile = tileArray[choice([0, 2, 6, 8])];
                            } else {
                                tile = tileArray[4];
                            }
                            break;

                        case 3:
                            if (et === "X" && (equalanyof([at, ct, gt, it], "O"))) {
                                /*To counter the strategy of
                                    O - -
                                    - X -
                                    X - -

                                    O - -
                                    - X -
                                    - - X
                                and related strategies*/
                                if (at === "X") {
                                    if (it === "none") {
                                        tile = tileArray[8];
                                    } else {
                                        tile = tileArray[choice([2, 6])];
                                    }
                                } else if (ct === "X") {
                                    if (gt === "none") {
                                        tile = tileArray[6];
                                    } else {
                                        tile = tileArray[choice([0, 8])];
                                    }
                                } else if (gt === "X") {
                                    if (ct === "none") {
                                        tile = tileArray[2];
                                    } else {
                                        tile = tileArray[choice([0, 8])];
                                    }
                                } else if (it === "X") {
                                    if (at === "none") {
                                        tile = tileArray[0];
                                    } else {
                                        tile = tileArray[choice([2, 6])];
                                    }
                                }
                            } else {
                                tile = choice(tileArray);
                            }
                            break;
                    }
                }

                //Generates a random number if it could cause an error
                if (tile.state != "none") {
                    tile = choice(available);
                }

                //Draws the selection
                tile.state = game.opp;
                tile.draw();
                checkCondition();
                game.turn = "Player";
            }
        }

        //Click handler
        document.onclick = event => {
            let pos = getMousePos(event);

            switch (game.state) {
                case "start":
                    //Checks if the button was clicked
                    if (isBetween(pos.x, width / 3.2, width / (16 / 11)) && isBetween(pos.y, width / 2, width / 1.6)) {
                        game.state = "game"

                        //Draws the setup for the game
                        ctx.fillStyle = "rgb(225, 225, 225)";
                        ctx.fillRect(0, 0, 400, 400);

                        //Draws the lines
                        ctx.fillStyle = "rgb(200, 200, 200)";
                        ctx.fillRect(blockSize - lineSize / 2, 0, lineSize, width);
                        ctx.fillRect(blockSize * 2 - lineSize / 2, 0, lineSize, width);
                        ctx.fillRect(0, blockSize - lineSize / 2, width, lineSize);
                        ctx.fillRect(0, blockSize * 2 - lineSize / 2, width, lineSize);
                    }
                    break;

                case "game":
                    if (game.turn === "Player") {
                        //Goes through the tile array, checking if the click occurred there
                        tileArray.forEach(tile => {
                            if (isBetween(pos.x, tile.x, tile.x + blockSize) && isBetween(pos.y, tile.y, tile.y + blockSize)) {
                                if (available.indexOf(tile) != -1) {
                                    tile.state = game.player;
                                    tile.draw();
                                    checkCondition();
                                    game.turn = "Opponent";
                                    oppTurn();
                                }
                            }
                        });
                    }
                    break;
            }

        }
    </script>
</body>

</html>
