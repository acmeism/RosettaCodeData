document.write(`
  <p>Choose dictionary: <input id="dict" type="file"></p>
  <p>Word length: <input id="wlen" type="number" value="9"</p>
  <div id="out"></div>
`);

function go(dict) {
  let wordLen = parseInt(document.getElementById('wlen').value),
      result = [];
  dict = dict.replace(/\n|\r/g, '_');
  dict = dict.replace(/__/g, ' ').split(' ');
  dict = dict.filter(e => e.length >= wordLen);
  for (let i = 0; i < dict.length - wordLen; i++) {
    let word = dict[i][0];
    for (let j = 1; j < wordLen; j++) {
      word += dict[i+j][j];
    }
    if (dict.includes(word) && !result.includes(word)) result.push(word);
  }
  document.getElementById('out').innerText = result.join(', ');
}

document.getElementById('dict').onchange = function() {
  let f = document.getElementById('dict').files[0],
      fr = new FileReader();
  fr.onload = function() { go(fr.result) }
  fr.readAsText(f);
}
