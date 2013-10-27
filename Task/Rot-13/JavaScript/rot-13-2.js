function rot13(value){
  if (!value)
    return "";

  function singleChar(c) {
    if (c.toUpperCase() < "A" || c.toUpperCase() > "Z")
      return c;

    if (c.toUpperCase() <= "M")
      return String.fromCharCode(c.charCodeAt(0) + 13);

    return String.fromCharCode(c.charCodeAt(0) - 13);
  }

  return _.map(value.split(""), singleChar).join("");
}

describe("Rot-13", function() {
  it("Given nothing will return nothing", function() {
    expect(rot13()).toBe("");
  });

  it("Given empty string will return empty string", function() {
    expect(rot13("")).toBe("");
  });

  it("Given A will return N", function() {
    expect(rot13("A")).toBe("N");
  });

  it("Given B will return O", function() {
    expect(rot13("B")).toBe("O");
  });

  it("Given N will return A", function() {
    expect(rot13("N")).toBe("A");
  });

  it("Given Z will return M", function() {
    expect(rot13("Z")).toBe("M");
  });

  it("Given ZA will return MN", function() {
    expect(rot13("ZA")).toBe("MN");
  });

  it("Given HELLO will return URYYB", function() {
    expect(rot13("HELLO")).toBe("URYYB");
  });

  it("Given hello will return uryyb", function() {
    expect(rot13("hello")).toBe("uryyb");
  });


  it("Given hello1 will return uryyb1", function() {
    expect(rot13("hello1")).toBe("uryyb1");
  });
});
