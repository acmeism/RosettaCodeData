import gleam/float
import gleam/io
import gleam/string

pub fn main() {
  convert(kelvin: 21.0)
}

pub fn convert(kelvin kelvin: Float) -> Nil {
  let rankine = kelvin *. 9.0 /. 5.0
  show_temp(kelvin, "K")
  show_temp(kelvin -. 273.15, "C")
  show_temp(rankine -. 459.67, "F")
  show_temp(rankine, "R")
}

fn show_temp(temperature: Float, unit: String) -> Nil {
  temperature
  |> float.to_precision(2)
  |> float.to_string
  |> string.append(" °" <> unit)
  |> io.println
}
