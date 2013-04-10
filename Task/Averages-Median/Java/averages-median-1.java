// Note: this function modifies the input list
public static double median(List<Double> list){
   Collections.sort(list);
   return (list.get(list.size() / 2) + list.get((list.size() - 1) / 2)) / 2;
}
