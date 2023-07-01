import std.algorithm;
import std.stdio;

auto square = (real x) => x * x;

auto meanSquareDiff(R)(real a, R predictions) {
    return predictions.map!(x => square(x - a)).mean;
}

void diversityTheorem(R)(real truth, R predictions) {
    auto average = predictions.mean;
    writeln("average-error: ", meanSquareDiff(truth, predictions));
    writeln("crowd-error: ", square(truth - average));
    writeln("diversity: ", meanSquareDiff(average, predictions));
    writeln;
}

void main() {
    diversityTheorem(49.0, [48.0, 47.0, 51.0]);
    diversityTheorem(49.0, [48.0, 47.0, 51.0, 42.0]);
}
