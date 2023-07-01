import std.numeric;
import std.range;
import std.stdio;

class Yellowstone {
    private bool[int] sequence_;
    private int min_ = 1;
    private int n_ = 0;
    private int n1_ = 0;
    private int n2_ = 0;

    public this() {
        popFront();
    }

    public bool empty() {
        return false;
    }

    public int front() {
        return n_;
    }

    public void popFront() {
        n2_ = n1_;
        n1_ = n_;
        if (n_ < 3) {
            ++n_;
        } else {
            for (n_ = min_;
                !(n_ !in sequence_ && gcd(n1_, n_) == 1 && gcd(n2_, n_) > 1);
                ++n_) {
                // empty
            }
        }
        sequence_[n_] = true;
        while (true) {
            if (min_ !in sequence_) {
                break;
            }
            sequence_.remove(min_);
            ++min_;
        }
    }
}

void main() {
    new Yellowstone().take(30).writeln();
}
