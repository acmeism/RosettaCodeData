template<class OutIt>
void read_words(std::istream& is, OutIt dest)
{
    typedef std::istream_iterator<std::string> InIt;
    std::copy(InIt(is), InIt(),
              dest);
}

namespace detail
{
    struct ReadableLine : public std::string
    {
        friend std::istream & operator>>(std::istream & is, ReadableLine & line)
        {
            return std::getline(is, line);
        }
    };
}

template<class OutIt>
void read_lines(std::istream& is, OutIt dest)
{
    typedef std::istream_iterator<detail::ReadableLine> InIt;
    std::copy(InIt(is), InIt(),
              dest);
}
