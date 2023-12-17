pub fn binarySearch(comptime T: type, input: []const T, search_value: T) ?usize {
    if (input.len == 0) return null;
    if (@sizeOf(T) == 0) return 0;

    var view: []const T = input;
    const item_ptr: *const T = item_ptr: while (view.len > 0) {
        const mid = (view.len - 1) / 2;
        const mid_elem_ptr: *const T = &view[mid];

        if (mid_elem_ptr.* > search_value)
            view = view[0..mid]
        else if (mid_elem_ptr.* < search_value)
            view = view[mid + 1 .. view.len]
        else
            break :item_ptr mid_elem_ptr;
    } else return null;

    const distance_in_bytes = @intFromPtr(item_ptr) - @intFromPtr(input.ptr);
    return (distance_in_bytes / @sizeOf(T));
}
