public static void triangle(int n){
        n= 1 << n;
        StringBuilder line= new StringBuilder(); //use a "mutable String"
        char t= 0;
        char u= 0; // avoid warnings
        for(int i= 0;i <= 2 * n;++i)
                line.append(" "); //start empty
        line.setCharAt(n, '*'); //with the top point of the triangle
        for(int i= 0;i < n;++i){
                System.out.println(line);
                u= '*';
                for(int j= n - i;j < n + i + 1;++j){
                        t= (line.charAt(j - 1) == line.charAt(j + 1) ? ' ' : '*');
                        line.setCharAt(j - 1, u);
                        u= t;
                }
                line.setCharAt(n + i, t);
                line.setCharAt(n + i + 1, '*');
        }
}
