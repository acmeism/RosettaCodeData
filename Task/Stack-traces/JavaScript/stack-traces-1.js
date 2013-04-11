try {
  throw new Error;
} catch(e) {
  alert(e.stack);
}
