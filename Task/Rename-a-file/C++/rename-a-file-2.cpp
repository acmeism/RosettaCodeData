#include "boost/filesystem.hpp"

int main()
{
    boost::filesystem::rename(
        boost::filesystem::path("input.txt"),
        boost::filesystem::path("output.txt"));
    boost::filesystem::rename(
        boost::filesystem::path("docs"),
        boost::filesystem::path("mydocs"));
    boost::filesystem::rename(
        boost::filesystem::path("/input.txt"),
        boost::filesystem::path("/output.txt"));
    boost::filesystem::rename(
        boost::filesystem::path("/docs"),
        boost::filesystem::path("/mydocs"));*/
    return 0;
}
