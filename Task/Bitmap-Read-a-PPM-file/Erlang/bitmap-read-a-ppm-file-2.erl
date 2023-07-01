Colorful = ppm:read("colorful.ppm"),
Gray = ros_bitmap:convert(ros_bitmap:convert(Colorful, grey), rgb),
ppm:write(Gray, "gray.ppm"),
