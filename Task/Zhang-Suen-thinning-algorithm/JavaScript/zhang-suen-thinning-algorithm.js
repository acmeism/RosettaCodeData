function Point(x, y) {
    this.x = x;
    this.y = y;
}
var ZhangSuen = (function () {
    function ZhangSuen() {
    }
    ZhangSuen.image =
    ["                                                          ",
     " #################                   #############        ",
     " ##################               ################        ",
     " ###################            ##################        ",
     " ########     #######          ###################        ",
     "   ######     #######         #######       ######        ",
     "   ######     #######        #######                      ",
     "   #################         #######                      ",
     "   ################          #######                      ",
     "   #################         #######                      ",
     "   ######     #######        #######                      ",
     "   ######     #######        #######                      ",
     "   ######     #######         #######       ######        ",
     " ########     #######          ###################        ",
     " ########     ####### ######    ################## ###### ",
     " ########     ####### ######      ################ ###### ",
     " ########     ####### ######         ############# ###### ",
     "                                                          "];

    ZhangSuen.nbrs = [[0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1]];

    ZhangSuen.nbrGroups = [[[0, 2, 4], [2, 4, 6]], [[0, 2, 6], [0, 4, 6]]];

    ZhangSuen.toWhite = new Array();
    ;
    ZhangSuen.main = function (args) {
        ZhangSuen.grid = new Array(ZhangSuen.image.length);
        for (var r = 0; r < ZhangSuen.image.length; r++)
            ZhangSuen.grid[r] = (ZhangSuen.image[r]).split('');
        ZhangSuen.thinImage();
    };
    ZhangSuen.thinImage = function () {
        var firstStep = false;
        var hasChanged;
        do {
            hasChanged = false;
            firstStep = !firstStep;
            for (var r = 1; r < ZhangSuen.grid.length - 1; r++) {
                for (var c = 1; c < ZhangSuen.grid[0].length - 1; c++) {
                    if (ZhangSuen.grid[r][c] !== '#')
                        continue;
                    var nn = ZhangSuen.numNeighbors(r, c);
                    if (nn < 2 || nn > 6)
                        continue;
                    if (ZhangSuen.numTransitions(r, c) !== 1)
                        continue;
                    if (!ZhangSuen.atLeastOneIsWhite(r, c, firstStep ? 0 : 1))
                        continue;
                    ZhangSuen.toWhite.push(new Point(c, r));
                    hasChanged = true;
                }
            }
            for (let i = 0; i < ZhangSuen.toWhite.length; i++) {
                var p = ZhangSuen.toWhite[i];
                ZhangSuen.grid[p.y][p.x] = ' ';
            }
            ZhangSuen.toWhite = new Array();
        } while ((firstStep || hasChanged));
        ZhangSuen.printResult();
    };
    ZhangSuen.numNeighbors = function (r, c) {
        var count = 0;
        for (var i = 0; i < ZhangSuen.nbrs.length - 1; i++)
            if (ZhangSuen.grid[r + ZhangSuen.nbrs[i][1]][c + ZhangSuen.nbrs[i][0]] === '#')
                count++;
        return count;
    };
    ZhangSuen.numTransitions = function (r, c) {
        var count = 0;
        for (var i = 0; i < ZhangSuen.nbrs.length - 1; i++)
            if (ZhangSuen.grid[r + ZhangSuen.nbrs[i][1]][c + ZhangSuen.nbrs[i][0]] === ' ') {
                if (ZhangSuen.grid[r + ZhangSuen.nbrs[i + 1][1]][c + ZhangSuen.nbrs[i + 1][0]] === '#')
                    count++;
            }
        return count;
    };
    ZhangSuen.atLeastOneIsWhite = function (r, c, step) {
        var count = 0;
        var group = ZhangSuen.nbrGroups[step];
        for (var i = 0; i < 2; i++)
            for (var j = 0; j < group[i].length; j++) {
                var nbr = ZhangSuen.nbrs[group[i][j]];
                if (ZhangSuen.grid[r + nbr[1]][c + nbr[0]] === ' ') {
                    count++;
                    break;
                }
            }
        return count > 1;
    };
    ZhangSuen.printResult = function () {
        for (var i = 0; i < ZhangSuen.grid.length; i++) {
            var row = ZhangSuen.grid[i];
            console.log(row.join(''));
        }
    };
    return ZhangSuen;
}());
ZhangSuen.main(null);
