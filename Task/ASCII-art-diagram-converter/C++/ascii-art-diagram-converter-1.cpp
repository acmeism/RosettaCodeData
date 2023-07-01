#include <array>
#include <bitset>
#include <iostream>

using namespace std;

struct FieldDetails {string_view Name; int NumBits;};

// parses the ASCII diagram and returns the field name, bit sizes, and the
// total byte size
template <const char *T> consteval auto ParseDiagram()
{
    // trim the ASCII diagram text
    constexpr string_view rawArt(T);
    constexpr auto firstBar = rawArt.find("|");
    constexpr auto lastBar = rawArt.find_last_of("|");
    constexpr auto art = rawArt.substr(firstBar, lastBar - firstBar);
    static_assert(firstBar < lastBar, "ASCII Table has no fields");

    // make an array for all of the fields
    constexpr auto numFields =
        count(rawArt.begin(), rawArt.end(), '|') -
        count(rawArt.begin(), rawArt.end(), '\n') / 2;
    array<FieldDetails, numFields> fields;

    // parse the diagram
    bool isValidDiagram = true;
    int startDiagramIndex = 0;
    int totalBits = 0;
    for(int i = 0; i < numFields; )
    {
        auto beginningBar = art.find("|", startDiagramIndex);
        auto endingBar = art.find("|", beginningBar + 1);
        auto field = art.substr(beginningBar + 1, endingBar - beginningBar - 1);
        if(field.find("-") == field.npos)
        {
            int numBits = (field.size() + 1) / 3;
            auto nameStart = field.find_first_not_of(" ");
            auto nameEnd = field.find_last_not_of(" ");
            if (nameStart > nameEnd || nameStart == string_view::npos)
            {
                // the table cannot be parsed
                isValidDiagram = false;
                field = ""sv;
            }
            else
            {
                field = field.substr(nameStart, 1 + nameEnd - nameStart);
            }
            fields[i++] = FieldDetails {field, numBits};
            totalBits += numBits;
        }
        startDiagramIndex = endingBar;
    }

    int numRawBytes = isValidDiagram ? (totalBits - 1) / 8 + 1 : 0;
    return make_pair(fields, numRawBytes);
}

// encode the values of the fields into a raw data array
template <const char *T> auto Encode(auto inputValues)
{
    constexpr auto parsedDiagram = ParseDiagram<T>();
    static_assert(parsedDiagram.second > 0, "Invalid ASCII talble");
    array<unsigned char, parsedDiagram.second> data;

    int startBit = 0;
    int i = 0;
    for(auto value : inputValues)
    {
        const auto &field = parsedDiagram.first[i++];
        int remainingValueBits = field.NumBits;
        while(remainingValueBits > 0)
        {
            // pack the bits from an input field into the data array
            auto [fieldStartByte, fieldStartBit] = div(startBit, 8);
            int unusedBits = 8 - fieldStartBit;
            int numBitsToEncode = min({unusedBits, 8, field.NumBits});
            int divisor = 1 << (remainingValueBits - numBitsToEncode);
            unsigned char bitsToEncode = value / divisor;
            data[fieldStartByte] <<= numBitsToEncode;
            data[fieldStartByte] |= bitsToEncode;
            value %= divisor;
            startBit += numBitsToEncode;
            remainingValueBits -= numBitsToEncode;
        }
    }

    return data;
}

// decode the raw data into the format of the ASCII diagram
template <const char *T> void Decode(auto data)
{
    cout << "Name      Bit Pattern\n";
    cout << "=======   ================\n";
    constexpr auto parsedDiagram = ParseDiagram<T>();
    static_assert(parsedDiagram.second > 0, "Invalid ASCII talble");

    int startBit = 0;
    for(const auto& field : parsedDiagram.first)
    {
        // unpack the bits from the data into a single field
        auto [fieldStartByte, fieldStartBit] = div(startBit, 8);
        unsigned char firstByte = data[fieldStartByte];
        firstByte <<= fieldStartBit;
        firstByte >>= fieldStartBit;
        int64_t value = firstByte;
        auto endBit = startBit + field.NumBits;
        auto [fieldEndByte, fieldEndBit] = div(endBit, 8);
        fieldEndByte = min(fieldEndByte, (int)(ssize(data) - 1));
        for(int index = fieldStartByte + 1; index <= fieldEndByte; index++)
        {
            value <<= 8;
            value += data[index];
        }
        value >>= fieldEndBit;
        startBit = endBit;

        cout << field.Name <<
            string_view("        ", (7 - field.Name.size())) << "   " <<
            string_view(bitset<64>(value).to_string()).substr(64 - field.NumBits, 64) <<  "\n";
    }

}

int main(void)
{
    static constexpr char art[] = R"(
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                      ID                       |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    QDCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ANCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    NSCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ARCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+)";

    // using the table above, encode the data below
    auto rawData = Encode<art> (initializer_list<int64_t> {
        30791,
        0, 15, 0, 1, 1, 1, 3, 15,
        21654,
        57646,
        7153,
        27044
    });

    cout << "Raw encoded data in hex:\n";
    for (auto v : rawData) printf("%.2X", v);
    cout << "\n\n";

    cout << "Decoded raw data:\n";
    Decode<art>(rawData);
}
