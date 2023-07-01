#include <filesystem>
#include <iostream>

namespace fs = std::filesystem;

int main(int argc, char* argv[])
{
	if(argc != 2)
	{
		std::cout << "usage: mkdir <path>\n";
		return -1;
	}

	fs::path pathToCreate(argv[1]);

	if (fs::exists(pathToCreate))
		return 0;

	if (fs::create_directories(pathToCreate))
		return 0;
	else
	{
		std::cout << "couldn't create directory: " << pathToCreate.string() << std::endl;
		return -1;
	}
}
