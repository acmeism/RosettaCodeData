public static double median2(List<Double> list) {
    PriorityQueue<Double> pq = new PriorityQueue<Double>(list);
    int n = list.size();
    for (int i = 0; i < (n - 1) / 2; i++)
        pq.poll(); // discard first half
    if (n % 2 != 0) // odd length
        return pq.poll();
    else
        return (pq.poll() + pq.poll()) / 2.0;
}
