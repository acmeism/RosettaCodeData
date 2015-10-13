#include <iostream>
int main(int argc, char* argv[]) {
  unsigned int in[] = {5, 50, 9000};        // Use int like most programming languages
  for (int i = 0; i < 3; i++)               // Use all inputs
    for (int at = 31; at >= 0; at--)        // reverse iteration from the max bit-length to 0, because msb is at the end
      if (int b = (in[i] >> at))            // skip leading zeros. Start output when significant bits are set
         std::cout << ('0' + b & 1) << (!at ? "\n": "");	// '0' or '1'. Add EOL if last bit of num
}
