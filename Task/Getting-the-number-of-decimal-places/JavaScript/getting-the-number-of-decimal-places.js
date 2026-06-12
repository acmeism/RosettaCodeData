function decimals() {
  const d = prompt("Enter a decimal number (trailing zeros allowed):");
  console.log(d.match(/\.\d+$/)[0].length - 1);
}
