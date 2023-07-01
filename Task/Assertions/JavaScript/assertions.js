function check() {
  try {
    if (isNaN(answer)) throw '$answer is not a number';
    if (answer != 42)  throw '$answer is not 42';
  }
  catch(err) {
    console.log(err);
    answer = 42;
  }
  finally { console.log(answer); }
}

console.count('try'); // 1
let answer;
check();

console.count('try'); // 2
answer = 'fourty two';
check();

console.count('try'); // 3
answer = 23;
check();
