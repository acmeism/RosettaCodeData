package com.rosettacode;

import java.util.LinkedList;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class DoubleLinkedListTraversing {

  public static void main(String[] args) {

    final LinkedList<String> doubleLinkedList =
        IntStream.range(1, 10)
            .mapToObj(String::valueOf)
            .collect(Collectors.toCollection(LinkedList::new));

    doubleLinkedList.iterator().forEachRemaining(System.out::print);
    System.out.println();
    doubleLinkedList.descendingIterator().forEachRemaining(System.out::print);
  }
}
