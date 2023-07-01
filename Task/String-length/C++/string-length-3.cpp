#include <string>
using std::wstring;

int main()
{
  wstring s = L"\u304A\u306F\u3088\u3046";
  wstring::size_type length = s.length();
}
