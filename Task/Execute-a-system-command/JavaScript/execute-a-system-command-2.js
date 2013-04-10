runCommand("cmd", "/c", "dir", "d:\\");
print("===");
var options = {
    // can specify arguments here in the options object
    args: ["/c", "dir", "d:\\"],
    // capture stdout to the options.output property
    output: ''
};
runCommand("cmd", options);
print(options.output);
