var myhash = {}; //a new, empty object
myhash["hello"] = 3;
myhash.world = 6; //obj.name is equivalent to obj["name"] for certain values of name
myhash["!"] = 9;

//iterate using for..in loop
for (var key in myhash) {
  //ensure key is in object and not in prototype
  if (myhash.hasOwnProperty(key)) {
    console.log("Key is: " + key + '. Value is: ' + myhash[key]);
  }
}

//iterate using ES5.1 Object.keys() and Array.prototype.Map()
var keys = Object.keys(); //get Array of object keys (doesn't get prototype keys)
keys.map(function (key) {
  console.log("Key is: " + key + '. Value is: ' + myhash[key]);
});
