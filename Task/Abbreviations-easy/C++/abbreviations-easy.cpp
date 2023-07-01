#include <algorithm>
#include <cctype>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

const char* command_table =
  "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy "
  "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find "
  "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput "
  "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO "
  "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT "
  "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT "
  "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up";

class command {
public:
    command(const std::string&, size_t);
    const std::string& cmd() const { return cmd_; }
    size_t min_length() const { return min_len_; }
    bool match(const std::string&) const;
private:
    std::string cmd_;
    size_t min_len_;
};

// cmd is assumed to be all uppercase
command::command(const std::string& cmd, size_t min_len)
    : cmd_(cmd), min_len_(min_len) {}

// str is assumed to be all uppercase
bool command::match(const std::string& str) const {
    size_t olen = str.length();
    return olen >= min_len_ && olen <= cmd_.length()
        && cmd_.compare(0, olen, str) == 0;
}

// convert string to uppercase
void uppercase(std::string& str) {
    std::transform(str.begin(), str.end(), str.begin(),
        [](unsigned char c) -> unsigned char { return std::toupper(c); });
}

size_t get_min_length(const std::string& str) {
    size_t len = 0, n = str.length();
    while (len < n && std::isupper(static_cast<unsigned char>(str[len])))
        ++len;
    return len;
}

class command_list {
public:
    explicit command_list(const char*);
    const command* find_command(const std::string&) const;
private:
    std::vector<command> commands_;
};

command_list::command_list(const char* table) {
    std::vector<command> commands;
    std::istringstream is(table);
    std::string word;
    while (is >> word) {
        // count leading uppercase characters
        size_t len = get_min_length(word);
        // then convert to uppercase
        uppercase(word);
        commands_.push_back(command(word, len));
    }
}

const command* command_list::find_command(const std::string& word) const {
    auto iter = std::find_if(commands_.begin(), commands_.end(),
        [&word](const command& cmd) { return cmd.match(word); });
    return (iter != commands_.end()) ? &*iter : nullptr;
}

std::string test(const command_list& commands, const std::string& input) {
    std::string output;
    std::istringstream is(input);
    std::string word;
    while (is >> word) {
        if (!output.empty())
            output += ' ';
        uppercase(word);
        const command* cmd_ptr = commands.find_command(word);
        if (cmd_ptr)
            output += cmd_ptr->cmd();
        else
            output += "*error*";
    }
    return output;
}

int main() {
    command_list commands(command_table);
    std::string input("riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin");
    std::string output(test(commands, input));
    std::cout << " input: " << input << '\n';
    std::cout << "output: " << output << '\n';
    return 0;
}
