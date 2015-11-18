void main() {
import std.file;
auto data = std.file.read("input.txt");
std.file.write("output.txt", data);
}
