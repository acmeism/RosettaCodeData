function bottleSong(n) {
  if (!isFinite(Number(n)) || n == 0) n = 100;
  var a  = '%% bottles of beer',
      b  = ' on the wall',
      c  = 'Take one down, pass it around',
      r  = '<br>'
      p  = document.createElement('p'),
      s  = [],
      re = /%%/g;

  while(n) {
    s.push((a+b+r+a+r+c+r).replace(re, n) + (a+b).replace(re, --n));
  }
  p.innerHTML = s.join(r+r);
  document.body.appendChild(p);
}

window.onload = bottleSong;
