const HYPHEN = '-';
const SPACE = ' ';
const UNDERSCORE = '_';
const WHITESPACE = " \n\r\t\f\v";

function leftTrim(text) {
  const start = text.search(/\S/); // Find the index of the first non-whitespace character
  return start === -1 ? "" : text.substring(start);
}

function rightTrim(text) {
  const end = text.search(/\S(?![\s\S]*\S)/); // Find the index of the last non-whitespace character
  return end === -1 ? "" : text.substring(0, end + 1);
}

function trim(text) {
  return leftTrim(rightTrim(text));
}

function prepareForConversion(text) {
  text = trim(text);
  text = text.replace(new RegExp(SPACE, 'g'), UNDERSCORE);
  text = text.replace(new RegExp(HYPHEN, 'g'), UNDERSCORE);
  return text; // Return the modified text
}

function toSnakeCase(camel) {
  camel = prepareForConversion(camel);
  let snake = "";
  let first = true;
  for (const ch of camel) {
    if (first) {
      snake += ch;
      first = false;
    } else if (!first && ch >= 'A' && ch <= 'Z') {
      if (snake.slice(-1) === UNDERSCORE) {
        snake += ch.toLowerCase();
      } else {
        snake += UNDERSCORE;
        snake += ch.toLowerCase();
      }
    } else {
      snake += ch;
    }
  }
  return snake;
}

function toCamelCase(snake) {
  snake = prepareForConversion(snake);
  let camel = "";
  let underscore = false;
  for (const ch of snake) {
    if (ch === UNDERSCORE) {
      underscore = true;
    } else if (underscore) {
      camel += ch.toUpperCase();
      underscore = false;
    } else {
      camel += ch;
    }
  }
  return camel;
}

function main() {
  const variableNames = ["snakeCase", "snake_case", "variable_10_case",
    "variable10Case", "ergo rE tHis", "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  "];

  console.log("".padEnd(48, " ") + "=== To snake_case ===");
  for (const text of variableNames) {
    console.log("".padEnd(34, " ") + text + " --> " + toSnakeCase(text));
  }

  console.log("\n");
  console.log("".padEnd(48, " ") + "=== To camelCase ===");
  for (const text of variableNames) {
    console.log("".padEnd(34, " ") + text + " --> " + toCamelCase(text));
  }
}

main();
