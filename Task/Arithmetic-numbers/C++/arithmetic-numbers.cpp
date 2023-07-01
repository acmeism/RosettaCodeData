#include <cstdio>

void divisor_count_and_sum(unsigned int n,
			   unsigned int& divisor_count,
			   unsigned int& divisor_sum)
{
  divisor_count = 0;
  divisor_sum = 0;
  for (unsigned int i = 1;; i++)
  {
    unsigned int j = n / i;
    if (j < i)
      break;
    if (i * j != n)
      continue;
    divisor_sum += i;
    divisor_count += 1;
    if (i != j)
    {
      divisor_sum += j;
      divisor_count += 1;
    }
  }
}

int main()
{
  unsigned int arithmetic_count = 0;
  unsigned int composite_count = 0;

  for (unsigned int n = 1; arithmetic_count <= 1000000; n++)
  {
    unsigned int divisor_count;
    unsigned int divisor_sum;
    divisor_count_and_sum(n, divisor_count, divisor_sum);
    unsigned int mean = divisor_sum / divisor_count;
    if (mean * divisor_count != divisor_sum)
      continue;
    arithmetic_count++;
    if (divisor_count > 2)
      composite_count++;
    if (arithmetic_count <= 100)
    {
      // would prefer to use <stream> and <format> in C++20
      std::printf("%3u ", n);
      if (arithmetic_count % 10 == 0)
	std::printf("\n");
    }
    if ((arithmetic_count == 1000) || (arithmetic_count == 10000) ||
	(arithmetic_count == 100000) || (arithmetic_count == 1000000))
    {
      std::printf("\n%uth arithmetic number is %u\n", arithmetic_count, n);
      std::printf("Number of composite arithmetic numbers <= %u: %u\n", n, composite_count);
    }
  }
  return 0;
}
