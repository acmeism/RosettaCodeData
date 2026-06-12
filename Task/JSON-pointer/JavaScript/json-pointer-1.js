class JSONPointer {
  #tokens;

  constructor(pointer) {
    this.#tokens = this.#parse(pointer);
  }

  resolve(data) {
    return this.#tokens.reduce(this.#getItem.bind(this), data);
  }

  toString() {
    return this.#encode(this.#tokens);
  }

  #parse(pointer) {
    if (pointer.length && !pointer.startsWith("/")) {
      throw new JSONPointerError(
        `\"${pointer}\" pointers must start with a slash or be the empty string`
      );
    }

    return pointer
      .split("/")
      .map((token) => token.replaceAll("~1", "/").replaceAll("~0", "~"))
      .slice(1);
  }

  #getItem(obj, token, idx) {
    // NOTE:
    //   - string primitives "have own" indices and `length`.
    //   - Arrays have a `length` property.
    //   - A property might exist with the value `undefined`.
    //   - obj[1] is equivalent to obj["1"].
    if (
      typeof obj === "object" &&
      !(Array.isArray(obj) && token === "length") &&
      Object.hasOwn(obj, token)
    )
      return obj[token];
    throw new JSONPointerError(
      `\"${this.#encode(this.#tokens.slice(0, idx + 1))}\" does not exist`
    );
  }

  #encode(tokens) {
    if (!tokens.length) return "";
    return (
      "/" +
      tokens
        .map((token) => token.replaceAll("~", "~0").replaceAll("/", "~1"))
        .join("/")
    );
  }
}

class JSONPointerError extends Error {}

const doc = {
  wiki: {
    links: [
      "https://rosettacode.org/wiki/Rosetta_Code",
      "https://discord.com/channels/1011262808001880065",
    ],
  },
  "": "Rosetta",
  " ": "Code",
  "g/h": "chrestomathy",
  "i~j": "site",
  abc: ["is", "a"],
  def: { "": "programming" },
};

const examples = [
  "",
  "/",
  "/ ",
  "/abc",
  "/def/",
  "/g~1h",
  "/i~0j",
  "/wiki/links/0",
  "/wiki/links/1",
  "/wiki/links/2",
  "/wiki/name",
  "/no/such/thing",
  "bad/pointer",
];

for (const p of examples) {
  try {
    const pointer = new JSONPointer(p);
    const result = pointer.resolve(doc);
    console.log(`"${p}" -> ${JSON.stringify(result, undefined, 2)}\n`);
  } catch (err) {
    if (err instanceof JSONPointerError) {
      console.log(`error: ${err.message}\n`);
    } else {
      throw err;
    }
  }
}
