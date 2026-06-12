import std.stdio;
import std.algorithm;
import std.range;
import std.array;

struct Point {
    int x;
    int y;
    Point opBinary(string op = "+")(Point o) { return Point( o.x + x, o.y + y ); }
}

struct Map {
    int w = 8;
    int h = 8;
    bool[][] m = [
            [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 1, 1, 0], [0, 0, 1, 0, 0, 0, 1, 0],
            [0, 0, 1, 0, 0, 0, 1, 0], [0, 0, 1, 1, 1, 1, 1, 0],
            [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0]
        ];
}

struct Node {
    Point pos;
    Point parent;
    int dist;
    int cost;
    bool opEquals(const Node n) { return pos == n.pos;  }
    bool opEquals(const Point p) { return pos == p;  }
    int opCmp(ref const Node n) const { return (n.dist + n.cost) - (dist + cost); }
};

struct AStar {
    Map m;
    Point end;
    Point start;
   	Point[8] neighbours = [Point(-1,-1), Point(1,-1), Point(-1,1), Point(1,1), Point(0,-1), Point(-1,0), Point(0,1), Point(1,0)];
    Node[] open;
    Node[] closed;

    int calcDist(Point b) {
        // need a better heuristic
        int x = end.x - b.x, y = end.y - b.y;
        return( x * x + y * y );
    }

    bool isValid(Point b) {
        return ( b.x >-1 && b.y > -1 && b.x < m.w && b.y < m.h );
    }

    bool existPoint(Point b, int cost) {
        auto i = closed.countUntil(b);
        if( i != -1 ) {
            if( closed[i].cost + closed[i].dist < cost ) return true;
            else { closed = closed.remove!(SwapStrategy.stable)(i); return false; }
        }
        i = open.countUntil(b);
        if( i != -1 ) {
            if( open[i].cost + open[i].dist < cost ) return true;
            else { open = open.remove!(SwapStrategy.stable)(i); return false; }
        }
        return false;
    }

    bool fillOpen( ref Node n ) {
        int stepCost;
        int nc;
        int dist;
        Point neighbour;

        for( int x = 0; x < 8; ++x ) {
            // one can make diagonals have different cost
            stepCost = x < 4 ? 1 : 1;
            neighbour = n.pos + neighbours[x];
            if( neighbour == end ) return true;

            if( isValid( neighbour ) && m.m[neighbour.y][neighbour.x] != 1 ) {
                nc = stepCost + n.cost;
                dist = calcDist( neighbour );
                if( !existPoint( neighbour, nc + dist ) ) {
                    Node m;
                    m.cost = nc; m.dist = dist;
                    m.pos = neighbour;
                    m.parent = n.pos;
                    open ~= m;
                }
            }
        }
        return false;
    }

    bool search( ref Point s, ref Point e, ref Map mp ) {
        Node n; end = e; start = s; m = mp;
        n.cost = 0;
        n.pos = s;
        n.parent = Point();
        n.dist = calcDist( s );
        open ~= n ;
        while( !open.empty() ) {
            //open.sort();
            Node nx = open.front();
            open = open.drop(1).array;
            closed ~= nx ;
            if( fillOpen( nx ) ) return true;
        }
        return false;
    }

    int path( ref Point[] path ) {
        path = end ~ path;
        int cost = 1 + closed.back().cost;
        path = closed.back().pos ~ path;
        Point parent = closed.back().parent;

        foreach(ref i ; closed.retro) {
            if( i.pos == parent && !( i.pos == start ) ) {
                path = i.pos ~ path;
                parent = i.parent;
            }
        }
        path = start ~ path;
        return cost;
    }
};

int main(string[] argv) {
    Map m;
    Point s;
    Point e = Point( 7, 7 );
    AStar as;

    if( as.search( s, e, m ) ) {
        Point[] path;
        int c = as.path( path );
        for( int y = -1; y < 9; y++ ) {
            for( int x = -1; x < 9; x++ ) {
                if( x < 0 || y < 0 || x > 7 || y > 7 || m.m[y][x] == 1 )
                    write(cast(char)0xdb);
                else {
                    if( path.canFind(Point(x,y)))
                        write("x");
                    else write(".");
                }
            }
            writeln();
        }

        write("\nPath cost ", c, ": ");
        foreach( i; path ) {
            write("(", i.x, ", ", i.y, ") ");
        }
    }
	write("\n\n");
    return 0;
}
