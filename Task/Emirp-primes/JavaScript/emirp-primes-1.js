function isPrime(n) {
    if (!(n % 2) || !(n % 3)) return 0;

    var p = 1;
    while (p * p < n) {
        if (n % (p += 4) == 0 || n % (p += 2) == 0) {
            return false
        }
    }
    return true
}

function isEmirp(n) {
    var s = n.toString();
    var r = s.split("").reverse().join("");
    return r != n && isPrime(n) && isPrime(r);
}

function main() {
    var out = document.getElementById("content");

    var c = 0;
    var x = 11;
    var last;
    var str;

    while (c < 10000) {
        if (isEmirp(x)) {
            c += 1;

            // first twenty emirps
            if (c == 1) {
                str = "<p>" + x;
            }
            else if (c < 20) {
                str += " " + x;
            }
            else if (c == 20) {
                out.innerHTML = str + " " + x + "</p>";
            }

            // all emirps between 7,700 and 8,000
            else if (7700 <= x && x <= 8001) {
                if (last < 7700) {
                    str = "<p>" + x;
                } else {
                    str += " " + x;
                }
            }
            else if (x > 7700 && last < 8001) {
                out.innerHTML += str + "</p>";
            }

            // the 10,000th emirp
            else if (c == 10000) {
                out.innerHTML += "<p>" + x + "</p>";
            }

            last = x;
        }
        x += 2;
    }
}
