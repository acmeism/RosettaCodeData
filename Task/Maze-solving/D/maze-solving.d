import std.stdio, std.random, std.string, std.array, std.algorithm,
       std.file, std.conv;

enum int cx = 4, cy = 2; // Cell size x and y.
enum int cx2 = cx / 2, cy2 = cy / 2;
enum pathSymbol = '.';
struct V2 { int x, y; }

bool solveMaze(char[][] maze, in V2 s, in V2 end) pure nothrow @safe @nogc {
    if (s == end)
        return true;

    foreach (immutable d; [V2(0, -cy), V2(+cx, 0), V2(0, +cy), V2(-cx, 0)])
        if (maze[s.y + (d.y / 2)][s.x + (d.x / 2)] == ' ' &&
            maze[s.y + d.y][s.x + d.x] == ' ') {
            maze[s.y + d.y][s.x + d.x] = pathSymbol;
            if (solveMaze(maze, V2(s.x + d.x, s.y + d.y), end))
                return true;
            maze[s.y + d.y][s.x + d.x] = ' ';
        }

    return false;
}

void main() {
    auto maze = "maze.txt".File.byLine.map!(r => r.chomp.dup).array;
    immutable h = (maze.length.signed - 1) / cy;
    assert (h > 0);
    immutable w = (maze[0].length.signed - 1) / cx;

    immutable start = V2(cx2 + cx * uniform(0, w), cy2 + cy * uniform(0, h));
    immutable end = V2(cx2 + cx * uniform(0, w), cy2 + cy * uniform(0, h));

    maze[start.y][start.x] = pathSymbol;
    if (!solveMaze(maze, start, end))
        return "No solution path found.".writeln;
    maze[start.y][start.x] = 'S';
    maze[end.y][end.x] = 'E';
    writefln("%-(%s\n%)", maze);
}
