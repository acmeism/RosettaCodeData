program Search_list_records;
{$mode ObjFPC}{$H+}

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
    (name: 'Casablanca'; population: 3.98)
  );

function FindCityIndex(const CityName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to High(Cities) do
    if Cities[i].name = CityName then
      Exit(i);
end;

function FindCityName(const pop: real): string;
var
  City: TCity;
begin
  Result := 'not found';
  for City in Cities do
    if City.population < pop then
      Exit(City.name);
end;

function FindCityPopulation(const Start: Char): Real;
var
  City: TCity;
begin
  Result := -1;
  for City in Cities do
    if City.name[1] = Start then
      Exit(City.population);
end;

begin
  writeln('index: ', FindCityIndex('Dar Es Salaam'));
  writeln('name: ', FindCityName(5.0));
  writeln('population: ', FindCityPopulation('A'):4:2);
end.
