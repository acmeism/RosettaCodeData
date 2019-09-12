const readline = require('readline');

async function menuSelect(question, choices) {
  if (choices.length === 0) return '';

  const prompt = choices.reduce((promptPart, choice, i) => {
    return promptPart += `${i + 1}. ${choice}\n`;
  }, '');

  let inputChoice = -1;
  while (inputChoice < 1 || inputChoice > choices.length) {
    inputChoice = await getSelection(`\n${prompt}${question}: `);
  }

  return choices[inputChoice - 1];
}

function getSelection(prompt) {
  return new Promise((resolve) => {
    const lr = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });

    lr.question(prompt, (response) => {
      lr.close();
      resolve(parseInt(response) || -1);
    });
  });
}

const choices = ['fee fie', 'huff and puff', 'mirror mirror', 'tick tock'];
const question = 'Which is from the three pigs?';
menuSelect(question, choices).then((answer) => {
  console.log(`\nYou chose ${answer}`);
});
