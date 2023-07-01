try {
  element.attachEvent('onclick', doStuff);
}
catch(e if e instanceof TypeError) {
  element.addEventListener('click', doStuff, false);
}
finally {
  eventSetup = true;
}
