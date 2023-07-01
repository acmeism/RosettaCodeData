Thread[] threads = new Thread[3];
threads[0] = new Thread(() -> System.out.println("enjoy"));
threads[1] = new Thread(() -> System.out.println("rosetta"));
threads[2] = new Thread(() -> System.out.println("code"));
Collections.shuffle(Arrays.asList(threads));
for (Thread thread : threads)
    thread.start();
