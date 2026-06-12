import std.file;
import std.random;
import std.range;
import std.stdio;
import std.string;

string markov(string filePath, int keySize, int outputSize) {
    if (keySize < 1) throw new Exception("Key size can't be less than 1");
    auto words = filePath.readText().chomp.split;
    if (outputSize < keySize || words.length < outputSize) {
        throw new Exception("Output size is out of range");
    }
    string[][string] dict;

    foreach (i; 0..words.length-keySize) {
        auto key = words[i..i+keySize].join(" ");
        string value;
        if (i+keySize<words.length) {
            value = words[i+keySize];
        }
        if (key !in dict) {
            dict[key] = [value];
        } else {
            dict[key] ~= value;
        }
    }

    string[] output;
    auto n = 0;
    auto rn = uniform(0, dict.length);
    auto prefix = dict.keys[rn];
    output ~= prefix.split;

    while (true) {
        auto suffix = dict[prefix];
        if (suffix.length == 1) {
            if (suffix[0] == "") return output.join(" ");
            output ~= suffix[0];
        } else {
            rn = uniform(0, suffix.length);
            output ~= suffix[rn];
        }
        if (output.length >= outputSize) return output.take(outputSize).join(" ");
        n++;
        prefix = output[n .. n+keySize].join(" ");
    }
}

void main() {
    writeln(markov("alice_oz.txt", 3, 200));
}
