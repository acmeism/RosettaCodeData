var myhash = {}; // a new, empty object
myhash["hello"] = 3;
myhash.world = 6;   // obj.name is equivalent to obj["name"] for certain values of name
myhash["!"] = 9;

var output = '', // initialise as string
    val;
for (val in myhash) {
    if (myhash.hasOwnProperty(val)) {
        output += "myhash['" + val + "'] is: " + myhash[val];
        output += "\n";
    }
}
