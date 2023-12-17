fetch('http://rosettacode.org').then(function (response) {
  return response.text();
}).then(function (text) {
  console.log(text);
});
