fn binary_search_recursive(arr: int*, value: int, low: int, high: int) -> int {
    if high < low {
        return -1;
    }

    let mid = low + (high - low) / 2;

    if arr[mid] > value {
        return binary_search_recursive(arr, value, low, mid - 1);
    } else if arr[mid] < value {
        return binary_search_recursive(arr, value, mid + 1, high);
    } else {
        return mid;
    }
}

fn main() {
    let arr: int[10] = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20];
    let n = 10;
    let targets: int[3] = [12, 5, 20];

    println "=> Recursive Binary Search";
    for target in targets {
        let index = binary_search_recursive(arr, target, 0, n - 1);
        if index != -1 {
            println "Value {target} found at index {index}.";
        } else {
            println "Value {target} not found.";
        }
    }
}
