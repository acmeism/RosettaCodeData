function parseConfig(config) {
    // this expression matches a line starting with an all capital word,
    // and anything after it
    var regex = /^([A-Z]+)(.*)$/mg;
    var configObject = {};

    // loop until regex.exec returns null
    var match;
    while (match = regex.exec(config)) {
        // values will typically be an array with one element
        // unless we want an array
        // match[0] is the whole match, match[1] is the first group (all caps word),
        // and match[2] is the second (everything through the end of line)
        var key = match[1], values = match[2].split(",");
        if (values.length === 1) {
            configObject[key] = values[0];
        }
        else {
            configObject[key] = values.map(function(value){
                return value.trim();
            });
        }
    }

    return configObject;
}
