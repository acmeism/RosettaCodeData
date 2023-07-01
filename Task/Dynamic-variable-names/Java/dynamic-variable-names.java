public static void main(String... args){
        HashMap<String, Integer> vars = new HashMap<String, Integer>();
        //The variable name is stored as the String. The var type of the variable can be
        //changed by changing the second data type mentiones. However, it must be an object
        //or a wrapper class.
        vars.put("Variable name", 3); //declaration of variables
        vars.put("Next variable name", 5);
        Scanner sc = new Scanner(System.in);
        String str = sc.next();
        vars.put(str, sc.nextInt()); //accpeting name and value from user

        System.out.println(vars.get("Variable name")); //printing of values
        System.out.println(vars.get(str));
}
