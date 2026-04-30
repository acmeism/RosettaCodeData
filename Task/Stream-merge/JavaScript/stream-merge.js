// ------------------------------------------------------------
// Helper that prints a number followed by a space (like C++ `display`)
function display(num) {
  process.stdout.write(num + ' ');
}

// ------------------------------------------------------------
// merge2 – merge two sorted collections and call `action` for each
// element in sorted order.
function merge2(c1, c2, action) {
  let i1 = 0;                 // index into c1
  let i2 = 0;                 // index into c2

  while (i1 < c1.length && i2 < c2.length) {
    if (c1[i1] <= c2[i2]) {
      action(c1[i1++]);
    } else {
      action(c2[i2++]);
    }
  }

  // copy the rest of c1 (if any)
  while (i1 < c1.length) {
    action(c1[i1++]);
  }

  // copy the rest of c2 (if any)
  while (i2 < c2.length) {
    action(c2[i2++]);
  }
}

// ------------------------------------------------------------
// mergeN – merge **any number** of sorted collections.
// `all` is an iterable (e.g. an array) that contains the
// collections to be merged.  `action` is called for each value
// in global sorted order.
function mergeN(action, all) {
  // Create a list of “ranges”: each entry keeps the source array
  // and the current index inside that array.
  const ranges = Array.from(all, col => ({
    arr: col,
    pos: 0,                // points to the next element to read
    end: col.length
  }));

  let done = false;
  while (!done) {
    done = true;
    let least = null;      // reference to the range that currently has the smallest element

    // Scan every range looking for the smallest next element.
    for (const r of ranges) {
      // skip exhausted ranges
      if (r.pos >= r.end) continue;

      if (least === null || r.arr[r.pos] < least.arr[least.pos]) {
        least = r;
      }
    }

    // If we found a non‑empty range, emit its element and advance it.
    if (least !== null) {
      done = false;
      action(least.arr[least.pos]);
      ++least.pos;
    }
  }
}

// ------------------------------------------------------------
// Demo – the same tests that the C++ `main` performed
(function main() {
  const v1 = [0, 3, 6];
  const v2 = [1, 4, 7];
  const v3 = [2, 5, 8];

  // merge2(v2, v1, display);
  merge2(v2, v1, display);
  console.log();                     // newline

  // mergeN(display, { v1 });
  mergeN(display, [v1]);
  console.log();

  // mergeN(display, { v3, v2, v1 });
  mergeN(display, [v3, v2, v1]);
  console.log();
})();
