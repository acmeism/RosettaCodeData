#include <iostream>
#include <bitset>
void printBits(int n) {                     // Use int like most programming languages.
  int iExp = 0;                             // Bit-length
  while (n >> iExp) ++iExp;                 // Could use template <log(x)*1.44269504088896340736>
  for (int at = iExp - 1; at >= 0; at--)    // Reverse iter from the bit-length to 0 - msb is at end
    std::cout << std::bitset<32>(n)[at];    // Show 1's, show lsb, hide leading zeros
  std::cout << '\n';
}
int main(int argc, char* argv[]) {
  printBits(5);
  printBits(50);
  printBits(9000);
} // for testing with n=0 printBits<32>(0);
