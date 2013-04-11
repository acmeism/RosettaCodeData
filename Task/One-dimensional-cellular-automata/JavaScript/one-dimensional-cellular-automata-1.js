function caStep(old) {
  var old = [0].concat(old, [0]); // Surround with dead cells.
  var state = []; // The new state.

  for (var i=1; i<old.length-1; i++) {
    switch (old[i-1] + old[i+1]) {
      case 0: state[i-1] = 0; break;
      case 1: state[i-1] = (old[i] == 1) ? 1 : 0; break;
      case 2: state[i-1] = (old[i] == 1) ? 0 : 1; break;
    }
  }
  return state;
}
