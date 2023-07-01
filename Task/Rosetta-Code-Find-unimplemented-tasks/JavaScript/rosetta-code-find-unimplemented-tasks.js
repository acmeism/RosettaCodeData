(function (strXPath) {
  var xr = document.evaluate(
      strXPath,
      document,
      null, 0, 0
    ),

    oNode = xr.iterateNext(),
    lstTasks = [];

  while (oNode) {
    lstTasks.push(oNode.title);
    oNode = xr.iterateNext();
  }

  return [
    lstTasks.length + " items found in " + document.title,
    ''
  ].concat(lstTasks).join('\n')

})(
  '//*[@id="mw-content-text"]/div[2]/table/tbody/tr/td/ul/li/a'
);
