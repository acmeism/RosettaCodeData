...
//check will be the number we are looking for
//nums will be the array we are searching through
public static int binarySearch(int[] nums, int check){
        int hi = nums.length - 1;
        int lo = 0;
        while(hi >= lo){
                int guess = lo + ((hi - lo) / 2);
                if(nums[guess] > check){
                        hi = guess - 1;
                }else if(nums[guess] < check){
                        lo = guess + 1;
                }else{
                        return guess;
                }
        }
        return -1;
}

public static void main(String[] args){
        int[] searchMe;
        int someNumber;
        ...
        int index = binarySearch(searchMe, someNumber);
        System.out.println(someNumber + ((index == -1) ? " is not in the array" : (" is at index " + index)));
        ...
}
