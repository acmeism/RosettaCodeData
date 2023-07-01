#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

template < class T >
void sort3( T& x, T& y, T& z) {
    std::vector<T> v{x, y, z};
    std::sort(v.begin(), v.end());
    x = v[0]; y = v[1]; z = v[2];
}
int main() {
    int xi = 77444, yi = -12, zi = 0;
    sort3( xi, yi, zi );
    std::cout << xi << "\n" << yi << "\n" << zi << "\n\n";

    std::string xs, ys, zs;
    xs = "lions, tigers, and";
    ys = "bears, oh my!";
    zs = "(from the \"Wizard of OZ\")";
    sort3( xs, ys, zs );
    std::cout << xs << "\n" << ys << "\n" << zs << "\n\n";

    float xf = 11.3f, yf = -9.7f, zf = 11.17f;
    sort3( xf, yf, zf );
    std::cout << xf << "\n" << yf << "\n" << zf << "\n\n";
}
