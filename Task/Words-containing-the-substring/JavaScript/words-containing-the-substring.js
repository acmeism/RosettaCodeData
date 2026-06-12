document.write(`
  <p>Select a file:        <input type="file" id="file"></p>
  <p>Get words containing: <input value="THE" type="text" id="cont"></p>
  <p>Min. word length:     <input type="number" value="12" id="len"></p>
  <div id="info"></div><div id="out"></div>
`);

function search(inp) {
  let cont = document.getElementById('cont').value.toUpperCase(),
      len  = parseInt(document.getElementById('len').value),
      out  = document.getElementById('out'),
      info = document.getElementById('info'),
      result = [], i;
  inp = inp.replace(/\n|\r/g, '_');
  inp = inp.replace(/__/g, ' ').split(' ');
  for (i = 0; i < inp.length; i++)
    if (inp[i].length >= len && inp[i].toUpperCase().indexOf(cont) != -1)
      result.push(inp[i]);
  info.innerHTML = `<h2>${result.length} matches found for ${cont}, min. length ${len}:</h2>`;
  out.innerText = result.join(', ');
}

document.getElementById('file').onchange = function() {
  let fr = new FileReader(),
      f = document.getElementById('file').files[0];
  fr.onload = function() { search(fr.result); }
  fr.readAsText(f);
}
