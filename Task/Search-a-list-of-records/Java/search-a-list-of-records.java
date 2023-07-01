import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Predicate;

/**
 * Represent a City and it's population.
 * City-Objects do have a natural ordering, they are ordered by their poulation (descending)
 */
class City implements Comparable<City> {
    private final String name;
    private final double population;

    City(String name, double population) {
        this.name = name;
        this.population = population;
    }

    public String getName() {
        return this.name;
    }

    public double getPopulation() {
        return this.population;
    }

    @Override
    public int compareTo(City o) {
        //compare for descending order. for ascending order, swap o and this
        return Double.compare(o.population, this.population);
    }
}

public class SearchListOfRecords {

    public static void main(String[] args) {

        //Array-of-City-Objects-Literal
        City[] datasetArray = {new City("Lagos", 21.),
                new City("Cairo", 15.2),
                new City("Kinshasa-Brazzaville", 11.3),
                new City("Greater Johannesburg", 7.55),
                new City("Mogadishu", 5.85),
                new City("Khartoum-Omdurman", 4.98),
                new City("Dar Es Salaam", 4.7),
                new City("Alexandria", 4.58),
                new City("Abidjan", 4.4),
                new City("Casablanca", 3.98)};

        //Since this is about "collections smarter that arrays", the Array is converted to a List
        List<City> dataset = Arrays.asList(datasetArray);

        //the City-Objects know that they are supposed to be compared by population
        Collections.sort(dataset);


        //Find the first City that matches the given predicate and print it's index in the dataset
        //the Predicate here is given in the form a Java 8 Lambda that returns true if the given name
        //Note that the Predicate is not limited to searching for names. It can operate on anything one can done with
        // and compared about City-Objects
        System.out.println(findIndexByPredicate(dataset, city -> city.getName().equals("Dar Es Salaam")));

        //Find the first City whose population matches the given Predicate (here: population <= 5.) and print it's name
        //here the value is returned an printed by the caller
        System.out.println(findFirstCityByPredicate(dataset, city -> city.getPopulation() <= 5.));

        //Find the first City that matches the given predicate (here: name starts with "A") and
        //apply the given consumer (here: print the city's population)
        //here the caller specifies what to do with the object. This is the most generic solution and could also be used to solve Task 2
        applyConsumerByPredicate(dataset, city -> city.getName().startsWith("A"), city -> System.out.println(city.getPopulation()));

    }

    /**
     * Finds a City by Predicate.
     * The predicate can be anything that can be done or compared about a City-Object.
     * <p>
     * Since the task was to "find the index" it is not possible to use Java 8's stream facilities to solve this.
     * The Predicate is used very explicitly here - this is unusual.
     *
     * @param dataset the data to operate on, assumed to be sorted
     * @param p       the Predicate that wraps the search term.
     * @return the index of the City in the dataset
     */
    public static int findIndexByPredicate(List<City> dataset, Predicate<City> p) {
        for (int i = 0; i < dataset.size(); i++) {
            if (p.test(dataset.get(i)))
                return i;
        }
        return -1;
    }

    /**
     * Finds and returns the name of the first City where the population matches the Population-Predicate.
     * This solutions makes use of Java 8's stream facilities.
     *
     * @param dataset   the data to operate on, assumed to be sorted
     * @param predicate a predicate that specifies the city searched. Can be "any predicate that can be applied to a City"
     * @return the name of the first City in the dataset whose population matches the predicate
     */
    private static String findFirstCityByPredicate(List<City> dataset, Predicate<City> predicate) {
        //turn the List into a Java 8 stream, so it can used in stream-operations
        //filter() by the specified predicate (to the right of this operation, only elements matching the predicate are left in the stream)
        //find the first element (which is "the first city..." from the task)
        //get() the actualy object (this is necessary because it is wrapped in a Java 8 Optional<T>
        //getName() the name and return it.
        return dataset.stream().filter(predicate).findFirst().get().getName();
    }

    /**
     * In specified dataset, find the first City whose name matches the specified predicate, and apply the specified consumer
     * <p>
     * Since this can be solved pretty much like the "find a city by population", this has been varied. The caller specifies what to do with the result.
     * So this method does not return anything, but requiers a "consumer" that processes the result.
     *
     * @param dataset      the data to operate on, assumed to be sorted
     * @param predicate    a predicate that specifies the city searched. Can be "any predicate that can be applied to a City"
     * @param doWithResult a Consumer that specified what to do with the results
     */
    private static void applyConsumerByPredicate(List<City> dataset, Predicate<City> predicate, Consumer<City> doWithResult) {
        //turn the List in to a Java 8 stream in stream-operations
        //filter() by the specified predicate (to the right of this operation, only elements matching the predicate are left in the stream)
        //find the first element (which is "the first city..." from the task)
        // if there is an element found, feed it to the Consumer
        dataset.stream().filter(predicate).findFirst().ifPresent(doWithResult);
    }
}
