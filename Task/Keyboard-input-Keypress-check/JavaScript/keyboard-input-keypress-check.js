let thePressedKey;

function handleKey(evt) {
  thePressedKey = evt;
  console.log(thePressedKey);
}

document.addEventListener('keydown', handleKey);
