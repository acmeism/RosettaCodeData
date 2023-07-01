function wrap (text, limit) {
  if (text.length > limit) {
    // find the last space within limit
    var edge = text.slice(0, limit).lastIndexOf(' ');
    if (edge > 0) {
      var line = text.slice(0, edge);
      var remainder = text.slice(edge + 1);
      return line + '\n' + wrap(remainder, limit);
    }
  }
  return text;
}
