function flatten(list) {
  for (let i = 0; i < list.length; i++) {
    while (true) {
      if (Array.isArray(list[i])) {
      	list.splice(i, 1, ...list[i]);
      } else {
      	break;
      }
    }
  }
  return list;
}
