function filename() {
  // get the current script's URL
  // or in the event of an embedded script, fall back to the document URL
  const src = document.currentScript.src || document.location.href;
  // parse out just the file name from the URL
  // (no trailing slashes, search params or anchor fragments)
  return src.replace(/[?#].*/, '').match(/[^\/]+/g);
}
