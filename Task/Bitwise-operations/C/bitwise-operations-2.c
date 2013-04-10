/* rotate x to the right by s bits */
unsigned int rotr(unsigned int x, unsigned int s)
{
	return (x >> s) | (x << 32 - s);
}
