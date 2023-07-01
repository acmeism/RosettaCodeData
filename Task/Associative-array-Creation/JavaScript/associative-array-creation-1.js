var assoc = {};

assoc['foo'] = 'bar';
assoc['another-key'] = 3;

// dot notation can be used if the property name is a valid identifier
assoc.thirdKey = 'we can also do this!';
assoc[2] = "the index here is the string '2'";

//using JavaScript's object literal notation
var assoc = {
  foo: 'bar',
  'another-key': 3 //the key can either be enclosed by quotes or not
};

//iterating keys
for (var key in assoc) {
  // hasOwnProperty() method ensures the property isn't inherited
  if (assoc.hasOwnProperty(key)) {
    alert('key:"' + key + '", value:"' + assoc[key] + '"');
  }
}
