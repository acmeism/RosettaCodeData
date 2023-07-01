String[][] list1 = {{"a","b","c"}, {"A", "B", "C"}, {"1", "2", "3"}};
        for (int i = 0; i < list1.length; i++) {
            for (String[] lista : list1) {
                System.out.print(lista[i]);
            }
            System.out.println();
        }
