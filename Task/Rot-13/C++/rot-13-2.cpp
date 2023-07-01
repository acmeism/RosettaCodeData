#include <iostream>
#include <string>
#include <boost/iostreams/concepts.hpp>    // output_filter
#include <boost/iostreams/operations.hpp>  // put
#include <boost/iostreams/filtering_stream.hpp>
#include <fstream>
namespace io = boost::iostreams;

class rot_output_filter : public io::output_filter
{
public:
    explicit rot_output_filter(int r=13):rotby(r),negrot(alphlen-r){};

    template<typename Sink>
    bool put(Sink& dest, int c){
        char uc = toupper(c);

        if(('A' <= uc) && (uc <= ('Z'-rotby)))
            c = c + rotby;
        else if ((('Z'-rotby) <= uc) && (uc <= 'Z'))
            c = c - negrot;
        return boost::iostreams::put(dest, c);
    };
private:
        static const int alphlen = 26;
        const int rotby;
        const int negrot;
};

int main(int argc, char *argv[])
{
    io::filtering_ostream out;
    out.push(rot_output_filter(13));
    out.push(std::cout);

    if (argc == 1) out << std::cin.rdbuf();
    else for(int i = 1; i < argc; ++i){
        std::ifstream in(argv[i]);
        out << in.rdbuf();
    }
}
