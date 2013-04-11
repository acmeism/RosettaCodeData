// disclaimer: i prefer gingerale

void main()
{
  array numbers = ({ "no more", "one", "two", "three", "four", "five", "six", "seven",
                     "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
                     "fifteen", "sixteen", "seventeen", "eighteen", "nineteen" });
  array decades = ({ "twenty", "thirty", "fourty", "fifty", "sixty", "seventy", "eighty",
                     "ninety" });

  foreach (decades;; string decade)
  {
    numbers += decade+(({ "" }) + numbers[1..9])[*];
  }
  numbers = reverse(numbers);

  array bottles = ((numbers[*]+" bottles of ale on the wall, ")[*] +
                   (numbers[*]+" bottles of ale.\n")[*]);

  bottles[-2] = replace(bottles[-2], "one bottles", "one bottle");

  string song = bottles * "take one down, pass it around,\n";
  write(song);
}
