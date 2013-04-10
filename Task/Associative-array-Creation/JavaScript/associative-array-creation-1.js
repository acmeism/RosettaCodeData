var assoc = {};
assoc['foo'] = 'bar';
assoc['another-key'] = 3;
assoc.thirdKey = 'we can also do this!'; // dot notation can be used if the property name
                                         // is a valid identifier
assoc[2] = 'the index here is the string "2"';
assoc[null] = 'this also works';
assoc[(function(){return 'expr';})()] = 'Can use expressions too';

for (var key in assoc) {
  if (assoc.hasOwnProperty(key)) {
    alert('key:"' + key + '", value:"' + assoc[key] + '"');
  }
}
