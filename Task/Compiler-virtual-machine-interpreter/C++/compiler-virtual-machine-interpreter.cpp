#include <cstdint>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

std::vector<std::string> split_string(const std::string& text, const char& delimiter) {
	std::vector<std::string> lines;
	std::istringstream stream(text);
	std::string line;
	while ( std::getline(stream, line, delimiter) ) {
		if ( ! line.empty() ) {
			lines.emplace_back(line);
		}
	}
    return lines;
}

std::string parseString(const std::string& text) {
	std::string result = "";
	uint32_t i = 0;
	while ( i < text.length() ) {
		if ( text[i] == '\\' && i + 1 < text.length() ) {
			if ( text[i + 1] == 'n' ) {
				result += "\n";
				i++;
			} else if ( text[i + 1] == '\\') {
				result += "\\";
				i++;
			}
		} else {
			result += text[i];
		}
		i++;
	}

	return result;
}

void add_to_codes(const uint32_t& number, std::vector<uint8_t>& codes) {
	for ( uint32_t i = 0; i < 32; i += 8 ) {
		codes.emplace_back((number >> i) & 0xff);
	}
}

uint32_t operand(const uint32_t& index, const std::vector<uint8_t>& codes) {
	uint32_t result = 0;
	for ( uint32_t i = index + 3; i >= index; --i ) {
		 result = ( result << 8 ) + codes[i];
	}

	return result;
}

struct VirtualMachineInfo {
	uint32_t data_size;
	std::vector<std::string> vm_strings;
	std::vector<uint8_t> codes;
};

enum class Op_code {
	HALT, ADD, SUB, MUL, DIV, MOD, LT, GT, LE, GE, EQ, NE, AND, OR, NEG, NOT,
	PRTC, PRTI, PRTS, FETCH, STORE, PUSH, JMP, JZ
};

std::unordered_map<std::string, Op_code> string_to_enum = {
	{ "halt",  Op_code::HALT  }, { "add",   Op_code::ADD   }, { "sub",   Op_code::SUB   },
	{ "mul",   Op_code::MUL   }, { "div",   Op_code::DIV   }, { "mod",   Op_code::MOD   },
	{ "lt",    Op_code::LT    }, { "gt",    Op_code::GT    }, { "le",    Op_code::LE    },
	{ "ge",    Op_code::GE    }, { "eq",    Op_code::EQ    }, { "ne",    Op_code::NE    },
	{ "and",   Op_code::AND   }, { "or",    Op_code::OR    }, { "neg",   Op_code::NEG   },
	{ "not",   Op_code::NOT   }, { "prtc",  Op_code::PRTC  }, { "prti",  Op_code::PRTI  },
	{ "prts",  Op_code::PRTS  }, { "fetch", Op_code::FETCH }, { "store", Op_code::STORE },
	{ "push",  Op_code::PUSH  }, { "jmp",   Op_code::JMP   }, { "jz",    Op_code::JZ    }
};

VirtualMachineInfo load_code(const std::string& file_path) {
	std::ifstream stream(file_path);
	std::vector<std::string> lines;
	std::string line;

	while ( std::getline(stream, line) ) {
	    lines.emplace_back(line);
	}

	line = lines.front();
	if ( line.substr(0, 3) == "lex" ) {
		lines.erase(lines.begin());
		line = lines.front();
	}

	std::vector<std::string> sections = split_string(line, ' ');
	const uint32_t data_size = std::stoi(sections[1]);
	const uint32_t string_count = std::stoi(sections[3]);

	std::vector<std::string> vm_strings = { };
	for ( uint32_t i = 1; i <= string_count; ++i ) {
		std::string content = lines[i].substr(1, lines[i].length() - 2);
		vm_strings.emplace_back(parseString(content));
	}

	uint32_t offset = 0;
	std::vector<uint8_t> codes = { };
	for ( uint32_t i = string_count + 1; i < lines.size(); ++i ) {
		sections = split_string(lines[i], ' ');
		offset = std::stoi(sections[0]);
		Op_code op_code = string_to_enum[sections[1]];
		codes.emplace_back(static_cast<uint8_t>(op_code));

		switch ( op_code ) {
			case Op_code::FETCH :
			case Op_code::STORE :
			    add_to_codes(std::stoi(sections[2].substr(1, sections[2].length() - 2)), codes); break;
			case Op_code::PUSH  : add_to_codes(std::stoi(sections[2]), codes); break;
			case Op_code::JMP   :
			case Op_code::JZ    : add_to_codes(std::stoi(sections[3]) - offset - 1, codes); break;
			default : break;
		}
	}

	return VirtualMachineInfo(data_size, vm_strings, codes);
}

void runVirtualMachine(const uint32_t& data_size, const std::vector<std::string>& vm_strings,
					   const std::vector<uint8_t>& codes) {
	const uint32_t word_size = 4;
	std::vector<int32_t> stack(data_size, 0);
	uint32_t index = 0;
	Op_code op_code;

	while ( op_code != Op_code::HALT ) {
		op_code = static_cast<Op_code>(codes[index]);
		index++;

		switch ( op_code ) {
			case Op_code::HALT  : break;
			case Op_code::ADD   : stack[stack.size() - 2] += stack.back(); stack.pop_back(); break;
			case Op_code::SUB   : stack[stack.size() - 2] -= stack.back(); stack.pop_back(); break;
			case Op_code::MUL   : stack[stack.size() - 2] *= stack.back(); stack.pop_back(); break;
			case Op_code::DIV   : stack[stack.size() - 2] /= stack.back(); stack.pop_back(); break;
			case Op_code::MOD   : stack[stack.size() - 2] %= stack.back(); stack.pop_back(); break;
			case Op_code::LT    :
				{ stack[stack.size() - 2] = ( stack[stack.size() - 2] < stack.back() ) ? 1 : 0;
				  stack.pop_back(); break;
				}
			case Op_code::GT    :
				{ stack[stack.size() - 2] = ( stack[stack.size() - 2] > stack.back() ) ? 1 : 0;
				  stack.pop_back(); break;
				}
			case Op_code::LE    :
			    { stack[stack.size() - 2] = ( stack[stack.size() - 2] <= stack.back() ) ? 1 : 0;
			      stack.pop_back(); break;
			    }
			case Op_code::GE    :
				{ stack[stack.size() - 2] = ( stack[stack.size() - 2] >= stack.back() ) ? 1 : 0;
				  stack.pop_back(); break;
				}
			case Op_code::EQ    :
				{ stack[stack.size() - 2] = ( stack[stack.size() - 2] == stack.back() ) ? 1 : 0;
				  stack.pop_back(); break;
				}
			case Op_code::NE    :
				{ stack[stack.size() - 2] = ( stack[stack.size() - 2] != stack.back() ) ? 1 : 0;
			      stack.pop_back(); break;
				}
			case Op_code::AND   :
				{ uint32_t value = ( stack[stack.size() - 2] != 0 && stack.back() != 0 ) ? 1 : 0;
				  stack[stack.size() - 2] = value; stack.pop_back(); break;
				}
			case Op_code::OR    :
				{ uint32_t value = ( stack[stack.size() - 2] != 0 || stack.back() != 0 ) ? 1 : 0;
				  stack[stack.size() - 2] = value; stack.pop_back(); break;
				}
			case Op_code::NEG   : stack.back() = -stack.back(); break;
			case Op_code::NOT   : stack.back() = ( stack.back() == 0 ) ? 1 : 0; break;
			case Op_code::PRTC  : std::cout << static_cast<char>(stack.back()); stack.pop_back(); break;
			case Op_code::PRTI  : std::cout << stack.back(); stack.pop_back(); break;
			case Op_code::PRTS  : std::cout << vm_strings[stack.back()]; stack.pop_back(); break;
			case Op_code::FETCH : { stack.emplace_back(stack[operand(index, codes)]);
									index += word_size; break;
								  }
			case Op_code::STORE : { stack[operand(index, codes)] = stack.back(); index += word_size;
									stack.pop_back(); break;
								  }
			case Op_code::PUSH  : stack.emplace_back(operand(index, codes)); index += word_size; break;
			case Op_code::JMP   : index += operand(index, codes); break;
			case Op_code::JZ    : { index += ( stack.back() == 0 ) ? operand(index, codes) : word_size;
									stack.pop_back(); break;
								  }
		}
	}
}

int main() {
	VirtualMachineInfo info = load_code("Compiler Test Cases/AsciiMandlebrot.txt");
	runVirtualMachine(info.data_size, info.vm_strings, info.codes);
}
