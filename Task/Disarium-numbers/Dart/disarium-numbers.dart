import "dart:math";
import "dart:io";
void main() {
    var count = 0;
    var i = 0;
    while (count < 19) {
        if (is_disarium(i)) {
            stdout.write("$i ");
            count++;
        }
        i++;
    }
}

bool is_disarium(numb) {
    var n = numb;
    var len = n.toString().length;
    var sum = 0;
    while (n > 0) {
        sum += (pow(n % 10, len)).toInt();
        n = (n / 10).toInt();
        len--;
    }
    return numb == sum;
}
