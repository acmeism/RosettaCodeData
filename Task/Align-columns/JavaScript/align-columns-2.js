//break up each string by '$'. The assumption is that the user wants the trailing $.
var data = [
  "Given$a$text$file$of$many$lines,$where$fields$within$a$line$",
  "are$delineated$by$a$single$'dollar'$character,$write$a$program",
  "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$",
  "column$are$separated$by$at$least$one$space.",
  "Further,$allow$for$each$word$in$a$column$to$be$either$left$",
  "justified,$right$justified,$or$center$justified$within$its$column."
].map(function (str) { return str.split('$'); })

//boilerplate: get longest array or string in array
var getLongest = function (arr) {
  return arr.reduce(function (acc, item) { return acc.length > item.length ? acc : item; }, 0);
};

//boilerplate: this function would normally be in a library like underscore, lodash, or ramda
var zip = function (items, toInsert) {
  toInsert = (toInsert === undefined) ? null : toInsert;
  var longestItem = getLongest(items);
  return longestItem.map(function (_unused, index) {
    return items.map(function (item) {
      return item[index] === undefined ? toInsert : item[index];
    });
  });
};

//here's the part that's not boilerplate
var makeColumns = function (formatting, data) {
  var zipData = zip(data, '');
  var makeSpaces = function (num) { return new Array(num + 1).join(' '); };
  var formattedCols = zipData.map(function (column) {
    var maxLen = getLongest(column).length;//find the maximum word length
    if (formatting === 'left') {
      return column.map(function (word) { return word + makeSpaces(maxLen - word.length); });
    } else if (formatting === 'right') {
      return column.map(function (word) { return makeSpaces(maxLen - word.length) + word; });
    } else {
      return column.map(function (word) {
        var spaces = maxLen - word.length,
            first = ~~(spaces / 2),
            last = spaces - first;
        return makeSpaces(first) + word + makeSpaces(last);
      });
    }
  });

  return zip(formattedCols).map(function (row) { return row.join(' '); }).join('\n');
};
