const fs = require('fs');

// formats for the data parameter in the function below: {col1: array | function, col2: array | function}

function addCols(path, data) {
  let csv = fs.readFileSync(path, 'utf8');
  csv = csv.split('\n').map(line => line.trim());
  let colNames = Object.keys(data);
  for (let i = 0; i < colNames.length; i++) {
    let c = colNames[i];
    if (typeof data[c] === 'function') {
      csv = csv.map((line, idx) => idx === 0
        ? line + ',' + c
        : line + ',' + data[c](line, idx)
      );
    } else if (Array.isArray(data[c])) {
      csv = csv.map((line, idx) => idx === 0
        ? line + ',' + c
        : line + ',' + data[c][idx - 1]
      );
    }
  }
  fs.createWriteStream(path, {
    flag: 'w',
    defaultEncoding: 'utf8'
  }).end(csv.join('\n'));
}

addCols('test.csv', {
    sum: function (line, idx) {
      let s = 0;
      line = line.split(',').map(d => +(d.trim()));
      for (let i = 0; i < line.length; i++) {
        s += line[i];
      }
      return s;
    },
    id: function(line, idx) {
      return idx;
    }
  });
