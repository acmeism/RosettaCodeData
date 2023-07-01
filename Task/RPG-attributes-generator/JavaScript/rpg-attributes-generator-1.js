function roll() {
  const stats = {
    total: 0,
    rolls: []
  }
  let count = 0;

  for(let i=0;i<=5;i++) {
    let d6s = [];

    for(let j=0;j<=3;j++) {
      d6s.push(Math.ceil(Math.random() * 6))
    }

    d6s.sort().splice(0, 1);
    rollTotal = d6s.reduce((a, b) => a+b, 0);

    stats.rolls.push(rollTotal);
    stats.total += rollTotal;
  }

  return stats;
}

let rolledCharacter = roll();

while(rolledCharacter.total < 75 || rolledCharacter.rolls.filter(a => a >= 15).length < 2){
  rolledCharacter = roll();
}

console.log(`The 6 random numbers generated are:
${rolledCharacter.rolls.join(', ')}

Their sum is ${rolledCharacter.total} and ${rolledCharacter.rolls.filter(a => a >= 15).length} of them are >= 15`);
