#include <algorithm>
#include <cctype>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

const char* command_table =
  "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 "
  "compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate "
  "3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 "
  "forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load "
  "locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 "
  "msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 "
  "refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left "
  "2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1";

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

bool parse_integer(const std::string& word, int& value) {
    try {
        size_t pos;
        int i = std::stoi(word, &pos, 10);
        if (pos < word.length())
            return false;
        value = i;
        return true;
    } catch (const std::exception& ex) {
        return false;
    }
}

// convert string to uppercase
void uppercase(std::string& str) {
    std::transform(str.begin(), str.end(), str.begin(),
        [](unsigned char c) -> unsigned char { return std::toupper(c); });
}

class command_list {
public:
    explicit command_list(const char*);
    const command* find_command(const std::string&) const;
private:
    std::vector<command> commands_;
};

command_list::command_list(const char* table) {
    std::istringstream is(table);
    std::string word;
    std::vector<std::string> words;
    while (is >> word) {
        uppercase(word);
        words.push_back(word);
    }
    for (size_t i = 0, n = words.size(); i < n; ++i) {
        word = words[i];
        // if there's an integer following this word, it specifies the minimum
        // length for the command, otherwise the minimum length is the length
        // of the command string
        int len = word.length();
        if (i + 1 < n && parse_integer(words[i + 1], len))
            ++i;
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
