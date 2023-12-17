function svgEl(tagName, attrs) {
  const el = document.createElementNS('http://www.w3.org/2000/svg', tagName);
  for (const key in attrs) el.setAttribute(key, attrs[key]);
  return el;
}

function yinYang(r, x, y, th = 1) {
  const cR = (dY, rad) => `M${x},${y + dY + rad} a${rad},${rad},0,1,1,.1,0z `;
  const arc = (dY, rad, cw = 1) => `A${rad},${rad},0,0,${cw},${x},${y + dY} `;
  const d = cR(0, r + th) + cR(r / 2, r / 6) + cR(-r / 2, r / 6)
    + `M${x},${y} ` + arc(r, r / 2, 0) + arc(-r, r) + arc(0, r / 2);
  return svgEl('path', {d, 'fill-rule': 'evenodd'});
}

const dialog = document.body.appendChild(document.createElement('dialog'));
const svg = dialog.appendChild(svgEl('svg', {width: 170, height: 120}));

svg.appendChild(yinYang(50.0, 60, 60));
svg.appendChild(yinYang(20.0, 140, 30));
dialog.showModal();
