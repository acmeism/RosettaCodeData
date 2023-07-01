/**
 * Compare and report strings lengths.
 *
 * @param {Element} input - a TextArea DOM element with input
 * @param {Element} output - a TextArea DOM element for output
 */
function compareStringsLength(input, output) {

  // Safe defaults.
  //
  output.value = "";
  let output_lines = [];

  // Split input into an array of lines.
  //
  let strings = input.value.split(/\r\n|\r|\n/g);

  // Is strings array empty?
  //
  if (strings && strings.length > 0) {

    // Remove leading and trailing spaces.
    //
    for (let i = 0; i < strings.length; i++)
      strings[i] = strings[i].trim();

    // Sort by lengths.
    //
    strings.sort((a, b) => a.length - b.length);

    // Remove empty strings.
    //
    while (strings[0] == "")
      strings.shift();

    // Check if any strings remain.
    //
    if (strings && strings.length > 0) {

      // Get min and max length of strings.
      //
      const min = strings[0].length;
      const max = strings[strings.length - 1].length;

      // Build output verses - longest strings first.
      //
      for (let i = strings.length - 1; i >= 0; i--) {
        let length = strings[i].length;
        let predicate;
        if (length == max) {
          predicate = "is the longest string";
        } else if (length == min) {
          predicate = "is the shortest string";
        } else {
          predicate = "is neither the longest nor the shortest string";
        }
        output_lines.push(`"${strings[i]}" has length ${length} and ${predicate}\n`);
      }

      // Send all lines from output_lines array to an TextArea control.
      //
      output.value = output_lines.join('');
    }
  }
}

document.getElementById("input").value = "abcd\n123456789\nabcdef\n1234567";
compareStringsLength(input, output);
