function Matrix(ary) {
    this.mtx = ary
    this.height = ary.length;
    this.width = ary[0].length;
}

Matrix.prototype.toString = function() {
    var s = []
    for (var i = 0; i < this.mtx.length; i++)
        s.push( this.mtx[i].join(",") );
    return s.join("\n");
}

// returns a new matrix
Matrix.prototype.transpose = function() {
    var transposed = [];
    for (var i = 0; i < this.width; i++) {
        transposed[i] = [];
        for (var j = 0; j < this.height; j++) {
            transposed[i][j] = this.mtx[j][i];
        }
    }
    return new Matrix(transposed);
}

var m = new Matrix([[1,1,1,1],[2,4,8,16],[3,9,27,81],[4,16,64,256],[5,25,125,625]]);
print(m);
print();
print(m.transpose());
