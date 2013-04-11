var xmlstr = '<Students>' +
  '<Student Name="April" Gender="F" DateOfBirth="1989-01-02" />' +
  '<Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />' +
  '<Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />' +
  '<Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">' +
    '<Pet Type="dog" Name="Rover" />' +
  '</Student>' +
  '<Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" />' +
'</Students>';

var list = xmlstr.match(/<Student .*? \/>/g);
var output = '';
for (var i = 0; i < list.length; i++) {
  if (i > 0) {
    output += ', ';
  }
  var tmp = list[i].match(/Name="(.*?)"/);
  output += tmp[1];
}

// Bounce it through a HTML element to handle Unicode for us
var l = document.createElement('p');
l.innerHTML = output;
alert(l.innerHTML);
