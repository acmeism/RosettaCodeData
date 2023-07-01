Set animals = {'Rat','Ox','Tiger','Rabbit','Dragon','Snake','Horse','Goat','Monkey','Rooster','Dog','Pig'};
Set elements = {'Wood', 'Fire', 'Earth', 'Metal', 'Water'};

String getElement(num year) {
  num element = ((year - 4) % 10 / 2);
  return elements.elementAt(element.floor());
}

String getAnimal(int year) {
  return animals.elementAt((year - 4) % 12);
}

String getYY(int year) {
  return (year % 2 == 0) ? 'Yang' : 'Yin';
}

void main() {
  Set years = {1935, 1938, 1968, 1972, 1976, 2017};
  //the zodiac cycle didnt start until 4 CE, so years <4 shouldnt be valid
  for (int i = 0; i < 6; i++) {
    int indice = years.elementAt(i);
    print('$indice is the year of the ${getElement(indice)} ${getAnimal(indice)} (${getYY(indice)}).');
  }
}
