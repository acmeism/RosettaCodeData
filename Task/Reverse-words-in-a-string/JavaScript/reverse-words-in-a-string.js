var strReversed =
"---------- Ice and Fire ------------\n\
\n\
fire, in end will world the say Some\n\
ice. in say Some\n\
desire of tasted I've what From\n\
fire. favor who those with hold I\n\
\n\
... elided paragraph last ...\n\
\n\
Frost Robert -----------------------";

function reverseString(s) {
  return s.split('\n').map(
    function (line) {
      return line.split(/\s/).reverse().join(' ');
    }
  ).join('\n');
}

console.log(
  reverseString(strReversed)
);
