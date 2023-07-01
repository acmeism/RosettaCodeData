convert_Kelvin <- function(K){
    if (!is.numeric(K))
      stop("\n Input has to be numeric")

    return(list(
      Kelvin = K,
      Celsius = K - 273.15,
      Fahreneit = K * 1.8 - 459.67,
      Rankine = K * 1.8
    ))

  }

  convert_Kelvin(21)
