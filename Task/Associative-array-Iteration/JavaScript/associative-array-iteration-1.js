var myhash = {}; // a new, empty object
myhash["hello"] = 3;
myhash.world = 6;   // obj.name is equivalent to obj["name"] for certain values of name
myhash["!"] = 9;

var output = '', // initialise as string
    key;
for (key in myhash) {
    if (myhash.hasOwnProperty(key)) {
        output += "key is: " + key;
        output += " => ";
        output += "value is: " + myhash[key];  // cannot use myhash.key, that would be myhash["key"]
        output += "\n";
    }
}
