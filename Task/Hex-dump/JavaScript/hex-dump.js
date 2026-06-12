// Generate UTF-16 LE bytes from a string.
function* utf16leBytes(str) {
  // Little endian byte order mark.
  yield 0xff;
  yield 0xfe;

  // Iterate code units.
  let code_unit;
  for (let i = 0; i < str.length; i++) {
    code_unit = str.charCodeAt(i);
    yield code_unit & 0xff;
    yield code_unit >>> 8;
  }
}

/**
 * Generate sequences of length {@link n} from items in iterable {@link it}.
 */
function* groupBy(it, n) {
  let chunk = [];
  for (const item of it) {
    chunk.push(item);
    if (chunk.length == n) {
      yield chunk;
      chunk = [];
    }
  }

  if (chunk.length) {
    yield chunk;
  }
}

/**
 * @callback Formatter
 * @param {Array<number>} chunk
 * @returns {string} {@link chunk} formatted for output on one line.
 */
function canonicalFormatter(chunk) {
  const bytesAsHex = chunk.map((byte) => byte.toString(16).padStart(2, "0"));
  const hex = `${bytesAsHex.slice(0, 8).join(" ")}  ${bytesAsHex
    .slice(8)
    .join(" ")}`.padEnd(48, " ");

  const ascii = chunk
    .map((byte) => (byte > 31 && byte < 127 ? String.fromCharCode(byte) : "."))
    .join("");

  return `${hex}  |${ascii}|`;
}

/**
 * @callback Formatter
 * @param {Array<number>} chunk
 * @returns {string} {@link chunk} formatted for output on one line.
 */
function binaryFormatter(chunk) {
  const bits = chunk
    .map((byte) => byte.toString(2).padStart(8, "0"))
    .join(" ")
    .padEnd(53, " ");

  const ascii = chunk
    .map((byte) => (byte > 31 && byte < 127 ? String.fromCharCode(byte) : "."))
    .join("");

  return `${bits}  |${ascii}|`;
}

/**
 * Generate a textual representation of bytes in {@link data} one line at a time.
 *
 * @param {Iterable<number>} data
 * @param {number} skip
 * @param {number} length
 * @param {Formatter} formatter
 * @param {number} chunkSize
 */
function* hexDumpLines(
  data,
  skip = 0,
  length = Infinity,
  formatter = canonicalFormatter,
  chunkSize = 16
) {
  const it = data[Symbol.iterator]();

  for (let i = 0; i < skip; i++) {
    it.next();
  }

  let offset = skip;
  let byteCount = 0;
  let line = "";

  for (let chunk of groupBy(data, chunkSize)) {
    // Discard excess bytes if we've overshot length.
    if (byteCount + chunk.length > length) {
      chunk = chunk.slice(0, length - byteCount);
    }

    line = formatter(chunk);
    yield `${offset.toString(16).padStart(8, "0")}  ${line}`;

    offset += chunkSize;
    byteCount += chunk.length;

    if (byteCount >= length) {
      break;
    }
  }

  // Final byte count
  yield (byteCount + skip).toString(16).padStart(8, "0");
}

/**
 * Log a hex dump of {@link data} to the console.
 *
 * @param {Iterable<number>} data
 * @param {number} skip
 * @param {number} length
 * @param {Formatter} formatter
 * @param {number} chunkSize
 */
function consoleHexDump(
  data,
  skip = 0,
  length = Infinity,
  formatter = canonicalFormatter,
  chunkSize = 16
) {
  for (const line of hexDumpLines(data, skip, length, formatter, chunkSize)) {
    console.log(line);
  }
}

const exampleData = "Rosetta Code is a programming chrestomathy site 😀.";
consoleHexDump(utf16leBytes(exampleData));
console.log("");
consoleHexDump(utf16leBytes(exampleData), 20, 25);
console.log("");
consoleHexDump(utf16leBytes(exampleData), 0, Infinity, binaryFormatter, 6);
