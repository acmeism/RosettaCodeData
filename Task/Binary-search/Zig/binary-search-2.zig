pub fn binarySearch(comptime T: type, input: []const T, search_value: T) ?usize {
    return binarySearchInner(T, input, search_value, @intFromPtr(input.ptr));
}

fn binarySearchInner(comptime T: type, input: []const T, search_value: T, start_address: usize) ?usize {
    if (input.len == 0) return null;
    if (@sizeOf(T) == 0) return 0;

    const mid = (input.len - 1) / 2;
    const mid_elem_ptr: *const T = &input[mid];

    return if (mid_elem_ptr.* > search_value)
        binarySearchInner(T, input[0..mid], search_value, start_address)
    else if (mid_elem_ptr.* < search_value)
        binarySearchInner(T, input[mid + 1 .. input.len], search_value, start_address)
    else
        (@intFromPtr(mid_elem_ptr) - start_address) / @sizeOf(T);
}
