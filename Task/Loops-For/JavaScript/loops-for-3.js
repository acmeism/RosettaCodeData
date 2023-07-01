var s = '';

range(5).forEach(
  function (line) {
    range(line).forEach(
      function () { s += '*'; }
    );
    s += '\n';
  }
);

console.log(s);
