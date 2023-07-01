self.addEventListener('message', function (event) {
  self.postMessage(event.data);
  self.close();
}, false);
