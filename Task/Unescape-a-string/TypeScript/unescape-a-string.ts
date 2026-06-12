/* An exception thrown when a string contains an invalid escape sequence. */
class UnescapeError extends Error {
  constructor(readonly message: string, readonly index: number) {
    super(message);
    Object.setPrototypeOf(this, new.target.prototype);
    this.name = "UnescapeError";
    this.index = index;
    this.message = `${message}, at index ${index}`;
  }
}

/* Unescape a JSON-like string value. */
function unescapeString(value: string): string {
  const rv: string[] = [];
  const length = value.length;
  let index = 0;
  let startIndex = 0;
  let codepoint: number;

  while (index < length) {
    const ch = value[index];
    if (ch === "\\") {
      index += 1; // Move past '\'

      switch (value[index]) {
        case '"':
          rv.push('"');
          break;
        case "\\":
          rv.push("\\");
          break;
        case "/":
          rv.push("/");
          break;
        case "b":
          rv.push("\x08");
          break;
        case "f":
          rv.push("\x0C");
          break;
        case "n":
          rv.push("\n");
          break;
        case "r":
          rv.push("\r");
          break;
        case "t":
          rv.push("\t");
          break;
        case "u":
          startIndex = index - 1;
          [codepoint, index] = decodeHexChar(value, index);
          rv.push(stringFromCodePoint(codepoint, startIndex));
          break;
        default:
          throw new UnescapeError(`unknown escape sequence`, index - 1);
      }
    } else {
      stringFromCodePoint(ch.codePointAt(0), index);
      rv.push(ch);
    }

    index += 1;
  }

  return rv.join("");
}

/* Decode a `\uXXXX` or `\uXXXX\uXXXX` escape sequence from _value_ at _index_. */
function decodeHexChar(value: string, index: number): [number, number] {
  const length = value.length;

  if (index + 4 >= length) {
    throw new UnescapeError(`incomplete escape sequence`, index - 1);
  }

  index += 1; // Move past 'u'
  let codepoint = parseHexDigits(value.slice(index, index + 4), index - 2);

  if (isLowSurrogate(codepoint)) {
    throw new UnescapeError(`unexpected low surrogate code point`, index - 2);
  }

  if (isHighSurrogate(codepoint)) {
    // Expect a surrogate pair.
    if (
      !(
        index + 9 < length &&
        value[index + 4] === "\\" &&
        value[index + 5] === "u"
      )
    ) {
      throw new UnescapeError(`incomplete escape sequence`, index - 2);
    }

    const lowSurrogate = parseHexDigits(
      value.slice(index + 6, index + 10),
      index + 4
    );

    if (!isLowSurrogate(lowSurrogate)) {
      throw new UnescapeError(`unexpected code point`, index + 4);
    }

    codepoint =
      0x10000 + (((codepoint & 0x03ff) << 10) | (lowSurrogate & 0x03ff));

    return [codepoint, index + 9];
  }

  return [codepoint, index + 3];
}

/* Parse a hexadecimal string as an integer. */
function parseHexDigits(digits: string, index: number): number {
  const encoder = new TextEncoder();
  let codepoint = 0;
  for (const digit of encoder.encode(digits)) {
    codepoint <<= 4;
    switch (digit) {
      case 48:
      case 49:
      case 50:
      case 51:
      case 52:
      case 53:
      case 54:
      case 55:
      case 56:
      case 57:
        codepoint |= digit - 48; // '0'
        break;
      case 65:
      case 66:
      case 67:
      case 68:
      case 69:
      case 70:
        codepoint |= digit - 65 + 10; // 'A'
        break;
      case 97:
      case 98:
      case 99:
      case 100:
      case 101:
      case 102:
        codepoint |= digit - 97 + 10; // 'a'
        break;
      default:
        throw new UnescapeError("invalid \\uXXXX escape sequence", index);
    }
  }
  return codepoint;
}

/* Check the codepoint is valid and return its string representation. */
function stringFromCodePoint(codepoint: number | undefined, index): string {
  if (codepoint === undefined || codepoint <= 0x1f) {
    throw new UnescapeError("invalid character", index);
  }

  try {
    return String.fromCodePoint(codepoint);
  } catch {
    throw new UnescapeError("invalid escape sequence", index);
  }
}

export function isHighSurrogate(codepoint: number): boolean {
  return codepoint >= 0xd800 && codepoint <= 0xdbff;
}

export function isLowSurrogate(codepoint: number): boolean {
  return codepoint >= 0xdc00 && codepoint <= 0xdfff;
}

const testCases = [
  "abc",
  "a☺c",
  'a\\"c',
  "\\u0061\\u0062\\u0063",
  "a\\\\c",
  "a\\u263Ac",
  "a\\\\u263Ac",
  "a\\uD834\\uDD1Ec",
  "a\\ud834\\udd1ec",
  "a\\u263",
  "a\\u263Xc",
  "a\\uDD1Ec",
  "a\\uD834c",
  "a\\uD834\\u263Ac",
];

for (const s of testCases) {
  try {
    console.log(`${s} -> ${unescapeString(s)}`);
  } catch (err) {
    if (err instanceof UnescapeError) {
      console.log(`${s} -> ${err.message}`);
    } else {
      throw err;
    }
  }
}
