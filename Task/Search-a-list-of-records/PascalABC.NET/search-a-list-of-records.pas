type
  TCity = record
    name: string;
    population: real;
  end;

const
  Cities: array of TCity = (
    (name: 'Lagos'; population: 21.0),
    (name: 'Cairo'; population: 15.2),
    (name: 'Kinshasa-Brazzaville'; population: 11.3),
    (name: 'Greater Johannesburg'; population: 7.55),
    (name: 'Mogadishu'; population: 5.85),
    (name: 'Khartoum-Omdurman'; population: 4.98),
    (name: 'Dar Es Salaam'; population: 4.7),
    (name: 'Alexandria'; population: 4.58),
    (name: 'Abidjan'; population: 4.4),
    (name: 'Casablanca'; population: 3.98));

begin
  cities.FindIndex(x -> x.name = 'Dar Es Salaam').Println;
  cities.Find(x -> x.population < 5).name.Println;
  cities.Find(x -> x.name[1] = 'A').population.Println;
end.
