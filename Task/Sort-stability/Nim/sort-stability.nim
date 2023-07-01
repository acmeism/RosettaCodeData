import algorithm

const Records = [(country: "UK", city: "London"),
                 (country: "US", city: "New York"),
                 (country: "US", city: "Birmingham"),
                 (country: "UK", city: "Birmingham")]

echo "Original order:"
for record in Records:
  echo record.country, " ", record.city
echo()

echo "Sorted by city name:"
for record in Records.sortedByIt(it.city):
  echo record.country, " ", record.city
echo()

echo "Sorted by country name:"
for record in Records.sortedByIt(it.country):
  echo record.country, " ", record.city
