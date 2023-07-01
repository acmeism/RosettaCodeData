shared void run() {

    void printKelvinConversions(Float kelvin) {
        value celsius = kelvin - 273.15;
        value rankine = kelvin * 9.0 / 5.0;
        value fahrenheit = rankine - 459.67;

        print("Kelvin:     ``formatFloat(kelvin, 2, 2)``
               Celsius:    ``formatFloat(celsius, 2, 2)``
               Fahrenheit: ``formatFloat(fahrenheit, 2, 2)``
               Rankine:    ``formatFloat(rankine, 2, 2)``");
    }

    printKelvinConversions(21.0);

}
