import std.stdio, std.outbuffer;

alias Matrix = uint[][];

string toString(Matrix m) {
    auto ob = new OutBuffer();
    foreach(row; m) {
        //The format specifier inside the %(...%) is
        //automatically applied to each element of a range
        //Thus prints each line flanked by |
        ob.writefln("|%(%2d %)|", row);
    }
    return ob.toString;
}

Matrix kronecker(Matrix m1, Matrix m2) {
    Matrix p = new uint[][m1.length*m2.length];
    foreach(r1i, r1; m1) {
        foreach(r2i, r2; m2) {
            auto rp = new uint[r1.length*r2.length];
            foreach(c1i, e1; r1) {
                    foreach(c2i, e2; r2) {
                        rp[c1i*r2.length+c2i] = e1*e2;
                    }
            }
            p[r1i*m2.length+r2i] = rp;
        }
    }
    return p;
}

void sample(Matrix m1, Matrix m2) {
    auto res = kronecker(m1, m2);
    writefln("Matrix A:\n%s\nMatrix B:\n%s\nA (X) B:\n%s", m1.toString, m2.toString, res.toString);
}

void main() {
    Matrix A = [[1,2],[3,4]];
    Matrix B = [[0,5],[6,7]];

    sample(A,B);

    Matrix C =
    [[0,1,0],
     [1,1,1],
     [0,1,0]];
    Matrix D =
    [[1,1,1,1],
     [1,0,0,1],
     [1,1,1,1]];

    sample(C,D);
}
