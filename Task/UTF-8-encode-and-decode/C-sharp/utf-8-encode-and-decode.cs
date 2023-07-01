using System;
using System.Text;

namespace Rosetta
{
    class Program
    {
        static byte[] MyEncoder(int codepoint) => Encoding.UTF8.GetBytes(char.ConvertFromUtf32(codepoint));
        static string MyDecoder(byte[] utf8bytes) => Encoding.UTF8.GetString(utf8bytes);
        static void Main(string[] args)
        {
            Console.OutputEncoding = Encoding.UTF8;  // makes sure it doesn't print rectangles...
            foreach (int unicodePoint in new int[] {  0x0041, 0x00F6, 0x0416, 0x20AC, 0x1D11E})
            {
                byte[] asUtf8bytes = MyEncoder(unicodePoint);
                string theCharacter = MyDecoder(asUtf8bytes);
                Console.WriteLine("{0,8} {1,5}     {2,-15}", unicodePoint.ToString("X4"), theCharacter, BitConverter.ToString(asUtf8bytes));
            }
        }
    }
}
/* Output:
 *  0041     A     41
    00F6     ö     C3-B6
    0416     Ж     D0-96
    20AC     €     E2-82-AC
   1D11E     𝄞     F0-9D-84-9E */
