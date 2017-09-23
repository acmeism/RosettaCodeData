public static Object[] concat(Object[] arr1, Object[] arr2) {
    Object[] res = new Object[arr1.length + arr2.length];

    System.arraycopy(arr1, 0, res, 0, arr1.length);
    System.arraycopy(arr2, 0, res, arr1.length, arr2.length);

    return res;
}
