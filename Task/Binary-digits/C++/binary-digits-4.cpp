#include <iostream>
int main(int argc, char* argv[]) {                        // Usage: program.exe 5 50 9000
  for (int i = 1; i < argc; i++)                          // argv[0] is program name
    for (int at = 31; at >= 0; at--)                      // reverse iteration from the max bit-length to 0, because msb is at the end
      if (int b = (atoi(argv[i]) >> at))                  // skip leading zeros
         std::cout << ('0' + b & 1) << (!at ? "\n": "");  // '0' or '1'. Add EOL if last bit of num
}
