#include <string>
#include <regex>
#include <algorithm>
#include <numeric>
#include <sstream>

bool CheckFormat(const std::string& isin)
{
	std::regex isinRegEpx(R"([A-Z]{2}[A-Z0-9]{9}[0-9])");
	std::smatch match;
	return std::regex_match(isin, match, isinRegEpx);
}

std::string CodeISIN(const std::string& isin)
{
	std::string coded;
	int offset = 'A' - 10;
	for (auto ch : isin)
	{
		if (ch >= 'A' && ch <= 'Z')
		{
			std::stringstream ss;
			ss << static_cast<int>(ch) - offset;
			coded += ss.str();
		}
		else
		{
			coded.push_back(ch);
		}
	}

	return std::move(coded);
}

bool CkeckISIN(const std::string& isin)
{
	if (!CheckFormat(isin))
		return false;

	std::string coded = CodeISIN(isin);
// from http://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers#C.2B.2B11
	return luhn(coded);
}


#include <iomanip>
#include <iostream>

int main()
{
	std::string isins[] = { "US0378331005", "US0373831005", "U50378331005",
							"US03378331005", "AU0000XVGZA3", "AU0000VXGZA3",
							"FR0000988040" };
	for (const auto& isin : isins)
	{
		std::cout << isin << std::boolalpha << " - " << CkeckISIN(isin) <<std::endl;
	}
	return 0;
}
