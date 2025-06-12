function deBruijn(k, n) {
  const a = new Array(k * n).fill(0);
  const seq = [];

  function db(t, p) {
    if (t > n) {
      if (n % p === 0) {
        for (let i = 1; i < p + 1; i++) {
          seq.push(a[i]);
        }
      }
    } else {
      a[t] = a[t - p];
      db(t + 1, p);
      let j = a[t - p] + 1;
      while (j < k) {
        a[t] = j & 0xFF;
        db(t + 1, t);
        j++;
      }
    }
  }

  db(1, 1);
  let buf = "";
  for (const i of seq) {
    buf += String(i);
  }
  return buf + buf.substring(0, n - 1);
}

function allDigits(s) {
  for (const c of s) {
    if (c < '0' || '9' < c) {
      return false;
    }
  }
  return true;
}

function validate(db) {
  const le = db.length;
  const found = new Array(10000).fill(0);
  const errs = [];

  // Check all strings of 4 consecutive digits within 'db'
  // to see if all 10,000 combinations occur without duplication.
  for (let i = 0; i < le - 3; i++) {
    const s = db.substring(i, i + 4);
    if (allDigits(s)) {
      const n = parseInt(s);
      found[n]++;
    }
  }

  for (let i = 0; i < 10000; i++) {
    if (found[i] === 0) {
      errs.push(`    PIN number ${i} missing`);
    } else if (found[i] > 1) {
      errs.push(`    PIN number ${i} occurs ${found[i]} times`);
    }
  }

  if (errs.length === 0) {
    console.log("  No errors found");
  } else {
    const pl = (errs.length === 1) ? "" : "s";
    console.log(`  ${errs.length} error${pl} found:`);
    for (const e of errs) {
      console.log(e);
    }
  }
}

function main() {
  const db = deBruijn(10, 4);

  console.log(`The length of the de Bruijn sequence is ${db.length}\n`);
  console.log("The first 130 digits of the de Bruijn sequence are: " + db.substring(0, 130));
  console.log("\nThe last 130 digits of the de Bruijn sequence are: " + db.substring(db.length - 130));
  console.log("\n");

  console.log("Validating the de Bruijn sequence:");
  validate(db);

  console.log("\nValidating the reversed de Bruijn sequence:");
  const rdb = db.split("").reverse().join("");
  validate(rdb);

  const by = db.split("");
  by[4443] = '.';
  console.log("\nValidating the overlaid de Bruijn sequence:");
  validate(by.join(""));
}

main();
