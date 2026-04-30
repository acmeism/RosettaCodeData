function filename() {
  const src = import.meta.url;
  return src.replace(/[?#].*/, '').match(/[^\/]+/g);
}
