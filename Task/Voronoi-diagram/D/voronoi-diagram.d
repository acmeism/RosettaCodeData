import std.random, std.algorithm, std.range, bitmap;

struct Point { int x, y; }

Point[] randomPoints(in size_t nPoints, in size_t nx, in size_t ny) {
    immutable RndPt = (int) => Point(uniform(0, nx), uniform(0, ny));
    return iota(nPoints).map!RndPt().array();
}

Image!RGB generateVoronoi(in Point[] pts,
                          in size_t nx, in size_t ny) {
    // Generate a random color for each site.
    immutable RndRBG = (int) => RGB(cast(ubyte)uniform(0, 256),
                                    cast(ubyte)uniform(0, 256),
                                    cast(ubyte)uniform(0, 256));
    const colors = iota(pts.length).map!RndRBG().array();

    // Generate diagram by coloring pixels with color of nearest site.
    auto img = new typeof(return)(nx, ny);
    foreach (immutable x; 0 .. nx)
        foreach (immutable y; 0 .. ny) {
            immutable dCmp = (in Point a, in Point b) nothrow =>
                ((a.x - x) ^^ 2 + (a.y - y) ^^ 2) <
                ((b.x - x) ^^ 2 + (b.y - y) ^^ 2);
            img[x, y] = colors[pts.length - minPos!dCmp(pts).length];
        }

    // Mark each site with a black dot.
    foreach (immutable p; pts)
        img[p.x, p.y] = RGB.black;
    return img;
}

void main() {
    enum imageWidth = 640,
         imageHeight = 480;
    randomPoints(150, imageWidth, imageHeight)
    .generateVoronoi(imageWidth, imageHeight)
    .savePPM6("voronoi.ppm");
}
