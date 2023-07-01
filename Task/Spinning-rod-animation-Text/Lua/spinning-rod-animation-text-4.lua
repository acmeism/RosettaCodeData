--
-- In some HUD element, or where text is output... such as 'Loading' ... try:
-- This would be called every frame and would result in Loading., Loading.., Loading..., Loading.., Loading.
--

-- This one will use a unique id: loading_dots and have a 1 second delay between frames.
-- In this example print would be draw.Text or something along those lines.
print( 'Loading' .. string.SimpleAnimation( STRING_ANIMATION_DOTS, 'loading_dots', 1 ) );

-- or


-- This one will use id default, and use the pre-defined delay which is 1/3 because it is defined in the map. If it wasn't, it would use the default of 1/8...
-- In this example print would be draw.Text or something along those lines.
print( 'Loading' .. string.SimpleAnimation( STRING_ANIMATION_DOTS ) );
