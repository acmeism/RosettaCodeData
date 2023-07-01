import tango.math.random.Random;

void main() {
    double[1000] list;
    auto r = new Random();
    foreach (ref l; list) {
        r.normalSource!(double)()(l);
        l = 1.0 + 0.5 * l;
    }
}
