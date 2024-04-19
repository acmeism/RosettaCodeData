bool isNumeric(const std::string& input) {
    return std::all_of(input.begin(), input.end(), ::isdigit);
}
