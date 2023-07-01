fetch('http://rosettacode.org').then(function(response) {
  return response.text();
}).then(function(myText) {
  console.log(myText);
});
