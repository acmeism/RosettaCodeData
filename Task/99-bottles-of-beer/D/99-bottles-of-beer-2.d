import std.stdio, std.conv;

string bottles(in size_t num) pure {
    static string bottlesRecurse(in size_t num) pure {
        return num.text ~ " bottles of beer on the wall,\n"
               ~ num.text ~ " bottles of beer!\n"
               ~ "Take one down, pass it around,\n"
               ~ (num - 1).text ~ " bottle" ~ ((num - 1 == 1) ? "" : "s")
               ~ " of beer on the wall.\n\n"
               ~ ((num > 2)
                  ? bottlesRecurse(num - 1)
                  : "1 bottle of beer on the wall,\n"
                  ~ "1 bottle of beer!\n"
                  ~ "Take one down, pass it around,\n"
                  ~ "No bottles of beer on the wall!\n\n");
    }

    return bottlesRecurse(num)
           ~ "Go to the store and buy some more...\n"
           ~ num.text ~ " bottles of beer on the wall!";
}

pragma(msg, 99.bottles);
void main() {}
