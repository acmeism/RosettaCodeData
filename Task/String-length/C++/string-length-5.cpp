#include <cwchar>  // for mbstate_t
#include <locale>

// give the character length for a given named locale
std::size_t char_length(std::string const& text, char const* locale_name)
{
  // locales work on pointers; get length and data from string and
  // then don't touch the original string any more, to avoid
  // invalidating the data pointer
  std::size_t len = text.length();
  char const* input = text.data();

  // get the named locale
  std::locale loc(locale_name);

  // get the conversion facet of the locale
  typedef std::codecvt<wchar_t, char, std::mbstate_t> cvt_type;
  cvt_type const& cvt = std::use_facet<cvt_type>(loc);

  // allocate buffer for conversion destination
  std::size_t bufsize = cvt.max_length()*len;
  wchar_t* destbuf = new wchar_t[bufsize];
  wchar_t* dest_end;

  // do the conversion
  mbstate_t state = mbstate_t();
  cvt.in(state, input, input+len, input, destbuf, destbuf+bufsize, dest_end);

  // determine the length of the converted sequence
  std::size_t length = dest_end - destbuf;

  // get rid of the buffer
  delete[] destbuf;

  // return the result
  return length;
}
