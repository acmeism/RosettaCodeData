var words = ["Enjoy", "Rosetta", "Code"];
var workers = [];

for (var i = 0; i < words.length; i++) {
  workers[i] = new Worker("concurrent_worker.js");
  workers[i].addEventListener('message', function (event) {
    console.log(event.data);
  }, false);
  workers[i].postMessage(words[i]);
}
