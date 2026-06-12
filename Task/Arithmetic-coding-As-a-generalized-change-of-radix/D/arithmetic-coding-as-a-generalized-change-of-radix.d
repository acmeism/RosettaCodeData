import std.array;
import std.bigint;
import std.stdio;
import std.typecons;

BigInt bigPow(BigInt b, BigInt e) {
    if (e == 0) {
        return BigInt(1);
    }

    BigInt result = 1;
    while (e > 1) {
        if (e % 2 == 0) {
            b *= b;
            e /= 2;
        } else {
            result *= b;
            b *= b;
            e = (e - 1) / 2;
        }
    }

    return b * result;
}

long[byte] cumulative_freq(long[byte] freq) {
    long[byte] cf;
    long total;
    foreach (i; 0..256) {
        byte b = cast(byte) i;
        if (b in freq) {
            cf[b] = total;
            total += freq[b];
        }
    }
    return cf;
}

Tuple!(BigInt, BigInt, long[byte]) arithmethic_coding(string str, long radix) {
    // Convert the string into a slice of bytes
    auto chars = cast(byte[]) str;

    // The frequency characters
    long[byte] freq;
    foreach (c; chars) {
        freq[c]++;
    }

    // The cumulative frequency
    auto cf = cumulative_freq(freq);

    // Base
    BigInt base = chars.length;

    // Lower bound
    BigInt lower = 0;

    // Product of all frequencies
    BigInt pf = 1;

    // Each term is multiplied by the product of the
    // frequencies of all previously occurring symbols
    foreach (c; chars) {
        BigInt x = cf[c];

        lower = lower*base + x*pf;
        pf = pf*freq[c];
    }

    // Upper bound
    auto upper = lower + pf;

    BigInt tmp = pf;
    auto powr = BigInt("0");

    while (true) {
        tmp = tmp / radix;
        if (tmp == 0) {
            break;
        }
        powr++;
    }

    auto diff = (upper-1) / bigPow(BigInt(radix), powr);

    return tuple(diff, powr, freq);
}

string arithmethic_decoding(BigInt num, long radix, BigInt pow, long[byte] freq) {
    BigInt powr = radix;

    BigInt enc = num * bigPow(powr, pow);

    BigInt base = 0;
    foreach (v; freq) {
        base += v;
    }

    // Create the cumulative frequency table
    auto cf = cumulative_freq(freq);

    // Create the dictionary
    byte[long] dict;
    foreach (k,v; cf) {
        dict[v] = k;
    }

    // Fill the gaps in the dictionary
    long lchar = -1;
    for (long i=0; i<base; i++) {
        if (i in dict) {
            lchar = dict[i];
        } else if (lchar != -1) {
            dict[i] = cast(byte) lchar;
        }
    }

    // Decode the input number
    auto decoded = appender!string;
    for (BigInt i=base-1; i>=0; i--) {
        pow = bigPow(base, i);

        auto div = enc / pow;

        auto c = dict[div.toLong];
        auto fv = freq[c];
        auto cv = cf[c];

        auto prod = pow * cv;
        auto diff = enc - prod;
        enc = diff / fv;

        decoded.put(c);
    }

    // Return the decoded output
    return decoded.data;
}

void main() {
    long radix = 10;

    foreach (str; ["DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT"]) {
        auto output = arithmethic_coding(str, radix);
        auto dec = arithmethic_decoding(output[0], radix, output[1], output[2]);
        writefln("%-25s=> %19s * %s^%s", str, output[0], radix, output[1]);

        if (str != dec) {
            throw new Exception("\tHowever that is incorrect!");
        }
    }
}
