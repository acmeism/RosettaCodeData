import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

public class DeepCopy {

    public static void main(String[] args) {
        Person p1 = new Person("Clark", "Kent", new Address("1 World Center", "Metropolis", "NY", "010101"));
        Person p2 = p1;

        System.out.printf("Demonstrate shallow copy.  Both are the same object.%n");
        System.out.printf("Person p1 = %s%n", p1);
        System.out.printf("Person p2 = %s%n", p2);
        System.out.printf("Set city on person 2.  City on both objects is changed.%n");
        p2.getAddress().setCity("New York");
        System.out.printf("Person p1 = %s%n", p1);
        System.out.printf("Person p2 = %s%n", p2);

        p1 = new Person("Clark", "Kent", new Address("1 World Center", "Metropolis", "NY", "010101"));
        p2 = new Person(p1);
        System.out.printf("%nDemonstrate copy constructor.  Object p2 is a deep copy of p1.%n");
        System.out.printf("Person p1 = %s%n", p1);
        System.out.printf("Person p2 = %s%n", p2);
        System.out.printf("Set city on person 2.  City on objects is different.%n");
        p2.getAddress().setCity("New York");
        System.out.printf("Person p1 = %s%n", p1);
        System.out.printf("Person p2 = %s%n", p2);

        p2 = (Person) deepCopy(p1);
        System.out.printf("%nDemonstrate serialization.  Object p2 is a deep copy of p1.%n");
        System.out.printf("Person p1 = %s%n", p1);
        System.out.printf("Person p2 = %s%n", p2);
        System.out.printf("Set city on person 2.  City on objects is different.%n");
        p2.getAddress().setCity("New York");
        System.out.printf("Person p1 = %s%n", p1);
        System.out.printf("Person p2 = %s%n", p2);

        p2 = (Person) p1.clone();
        System.out.printf("%nDemonstrate cloning.  Object p2 is a deep copy of p1.%n");
        System.out.printf("Person p1 = %s%n", p1);
        System.out.printf("Person p2 = %s%n", p2);
        System.out.printf("Set city on person 2.  City on objects is different.%n");
        p2.getAddress().setCity("New York");
        System.out.printf("Person p1 = %s%n", p1);
        System.out.printf("Person p2 = %s%n", p2);
    }

    /**
     * Makes a deep copy of any Java object that is passed.
     */
    private static Object deepCopy(Object object) {
        try {
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            ObjectOutputStream outputStrm = new ObjectOutputStream(outputStream);
            outputStrm.writeObject(object);
            ByteArrayInputStream inputStream = new ByteArrayInputStream(outputStream.toByteArray());
            ObjectInputStream objInputStream = new ObjectInputStream(inputStream);
            return objInputStream.readObject();
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static class Address implements Serializable, Cloneable {

        private static final long serialVersionUID = -7073778041809445593L;

        private String street;
        private String city;
        private String state;
        private String postalCode;
        public String getStreet() {
            return street;
        }
        public String getCity() {
            return city;
        }
        public void setCity(String city) {
            this.city = city;
        }
        public String getState() {
            return state;
        }
        public String getPostalCode() {
            return postalCode;
        }

        @Override
        public String toString() {
            return "[street=" + street + ", city=" + city + ", state=" + state + ", code=" + postalCode + "]";
        }

        public Address(String s, String c, String st, String p) {
            street = s;
            city = c;
            state = st;
            postalCode = p;
        }

        //  Copy constructor
        public Address(Address add) {
            street    = add.street;
            city       = add.city;
            state      = add.state;
            postalCode = add.postalCode;
        }

        //  Support Cloneable
        @Override
        public Object clone() {
            return new Address(this);
        }

    }

    public static class Person implements Serializable, Cloneable {
        private static final long serialVersionUID = -521810583786595050L;
        private String firstName;
        private String lastName;
        private Address address;
        public String getFirstName() {
            return firstName;
        }
        public String getLastName() {
            return lastName;
        }
        public Address getAddress() {
            return address;
        }

        @Override
        public String toString() {
            return "[first name=" + firstName + ", last name=" + lastName + ", address=" + address + "]";
        }

        public Person(String fn, String ln, Address add) {
            firstName = fn;
            lastName = ln;
            address = add;
        }

        //  Copy Constructor
        public Person(Person person) {
            firstName = person.firstName;
            lastName = person.lastName;
            address = new Address(person.address);  //  Invoke copy constructor of mutable sub-objects.
        }

        //  Support Cloneable
        @Override
        public Object clone() {
            return new Person(this);
        }
    }
}
