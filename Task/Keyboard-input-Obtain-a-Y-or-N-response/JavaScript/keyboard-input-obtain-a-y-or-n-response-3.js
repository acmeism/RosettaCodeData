document.body.addEventListener('keyup', function (e) {
  var key = String.fromCharCode(e.keyCode).toLowerCase();
  if (key === 'y' || key === 'n') {
    console.log('response is: ' + key);
  }
}, false);
