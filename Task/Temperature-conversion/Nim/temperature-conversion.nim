import rdstdin, strutils, strfmt

while true:
  let k = parseFloat readLineFromStdin "K ? "
  echo "{:g} Kelvin = {:g} Celsius = {:g} Fahrenheit = {:g} Rankine degrees".fmt(
    k, k - 273.15, k * 1.8 - 459.67, k * 1.8)
