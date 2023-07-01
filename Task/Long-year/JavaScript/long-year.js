const isLongYear = (year) => {
  const jan1 = new Date(year, 0, 1);
  const dec31 = new Date(year, 11, 31);
  return (4 == jan1.getDay() || 4 == dec31.getDay())
}

for (let y = 1995; y <= 2045; y++) {
  if (isLongYear(y)) {
    console.log(y)
  }
}
