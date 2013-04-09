public static void main(String[] args){
        int[] searchMe;
        int someNumber;
        ...
        int index = binarySearch(searchMe, someNumber, 0, searchMe.length);
        System.out.println(someNumber + ((index == -1) ? " is not in the array" : (" is at index " + index)));
        ...
}

public static int binarySearch(int[] nums, int check, int lo, int hi){
        if(hi < lo){
                return -1; //impossible index for "not found"
        }
        int guess = (hi + lo) / 2;
        if(nums[guess] > check){
                return binarySearch(nums, check, lo, guess - 1);
        }else if(nums[guess]<check){
                return binarySearch(nums, check, guess + 1, hi);
        }
        return guess;
}
