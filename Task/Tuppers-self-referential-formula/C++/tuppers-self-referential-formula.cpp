#include <iostream>

#include <boost/multiprecision/cpp_int.hpp>
#include <boost/multiprecision/integer.hpp>

int main() {
    using boost::multiprecision::cpp_int;
    using boost::multiprecision::pow;

    const cpp_int k(
        "9609393799189588849716729621278527547150043396601293066515055192717028"
        "0239526642468964284217435071812126715378277062335599323728087414430789"
        "1325963941337723487857735749823926629715517173716995165232890538221612"
        "4032388558661840132355851360488286933379024914542292886670810961844960"
        "9170518345406782773155170540538162738096760256562501698148208341878316"
        "3849115590225610003652351370343874461848378737238198224849863465033159"
        "4100549747005931383392264972494617515457283667023697454610146559979337"
        "98537483143786841806593422227898388722980000748404719");
    const int rows = 17;
    const int columns = 106;
    const cpp_int two(2);

    for (int row = 0; row < rows; ++row) {
        for (int column = columns - 1; column >= 0; --column) {
            cpp_int y = k + row;
            int b = static_cast<int>(y % 17) + column * 17;
            cpp_int a = (y / 17) / pow(two, b);
            std::cout << ((a % 2 == 1) ? u8"\u2588" : u8" ");
        }
        std::cout << '\n';
    }
}
