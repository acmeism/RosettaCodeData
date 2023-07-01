public class Crc32
{
  private const uint32 s_generator = 0xedb88320u;

  public Crc32()
  {
    m_table = new uint32[256];
    uint32 rem;
    for (uint32 i = 0; i < 256; i++) {
      rem = i;
      for (uint32 j = 0; j < 8; j++) {
        if ((rem & 1) != 0) {
          rem >>= 1;
          rem ^= s_generator;
        } else
          rem >>= 1;
      }
      m_table[i] = rem;
    }
  }

  public uint32 get(string str) {
    uint32 crc = 0;
    crc = ~crc;
    for (int i = 0; i < str.length; i++) {
      crc = (crc >> 8) ^ m_table[(crc & 0xff) ^ str[i]];
    }
    return ~crc;
  }

  private uint32[] m_table;
}

void main() {
  var crc32 = new Crc32();
  stdout.printf("%x\n", crc32.get("The quick brown fox jumps over the lazy dog"));
}
