#include <chrono>
#include <format>
#include <iostream>
#include <regex>
#include <sstream>
#include <string>

const std::string ELEMENTS = R"(
	hydrogen     helium        lithium      beryllium
	boron        carbon        nitrogen     oxygen
	fluorine     neon          sodium       magnesium
	aluminum     silicon       phosphorous  sulfur
	chlorine     argon         potassium    calcium
	scandium     titanium      vanadium     chromium
	manganese    iron          cobalt       nickel
	copper       zinc          gallium      germanium
	arsenic      selenium      bromine      krypton
	rubidium     strontium     yttrium      zirconium
	niobium      molybdenum    technetium   ruthenium
	rhodium      palladium     silver       cadmium
	indium       tin           antimony     tellurium
	iodine       xenon         cesium       barium
	lanthanum    cerium        praseodymium neodymium
	promethium   samarium      europium     gadolinium
	terbium      dysprosium    holmium      erbium
	thulium      ytterbium     lutetium     hafnium
	tantalum     tungsten      rhenium      osmium
	iridium      platinum      gold         mercury
	thallium     lead          bismuth      polonium
	astatine     radon         francium     radium
	actinium     thorium       protactinium uranium
	neptunium    plutonium     americium    curium
	berkelium    californium   einsteinium  fermium
	mendelevium  nobelium      lawrencium   rutherfordium
	dubnium      seaborgium    bohrium      hassium
	meitnerium   darmstadtium  roentgenium  copernicium
	nihonium     flerovium     moscovium    livermorium
	tennessine   oganesson
	)";

const std::string UNNAMED_ELEMENTS = R"(
	ununennium     unquadnilium triunhexium penthextrium
	penthexpentium septhexunium octenntrium ennennbium
	)";

std::vector<std::string> rawstring_to_vector(const std::string& text, const char& delimiter) {
	std::regex regx("\\s+");
	std::string delimit(1, delimiter);
	std::string elements = std::regex_replace(text, regx, delimit);
	elements = elements.substr(1, elements.size() - 2);

    std::vector<std::string> result;
    std::stringstream stream(elements);
    std::string item;
    while ( getline(stream, item, delimiter) ) {
        result.push_back (item);
    }
    return result;
}

int main() {
	std::vector<std::string> elements = rawstring_to_vector(ELEMENTS, ' ');
	std::vector<std::string> unnamed = rawstring_to_vector(UNNAMED_ELEMENTS, ' ');

	elements.erase(std::remove_if(elements.begin(), elements.end(),
		[unnamed](std::string text){ return std::find(unnamed.begin(), unnamed.end(), text) != unnamed.end(); }),
		elements.end());

	const std::string zone = "Asia/Shanghai";
	const std::chrono::zoned_time zoned_time { zone, std::chrono::system_clock::now() };

	std::cout << "Last revision Date:  " << std::format("{:%Y-%m-%d Time %H:%M}", zoned_time)
              << " " << zone << std::endl;
	std::cout << "Number of elements:  " << elements.size() << std::endl;
	std::cout << "Last element      :  " << elements[elements.size() - 1] << std::endl;
}
