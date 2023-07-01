--
-- Example - This is one way it could be used without rendering it every frame... Pseudo code and a task which is a good idea to do - when the map is added, add a function to register the animation and also go through each animation index and see which element is
--	the largest then save the largest segment in another key so we can, based on font size, etc.. get the width / height of the resulting output so we can ensure our elements don't have to do ugly sliding action when rendering...
--


--
-- Initialization function
--
function PANEL:Initialize( )
	-- Create the button and set the base text ( assume first arg ) as the language key ( also assume it handles referencing the correct word in GetBaseText )
	self.button = self:CreateButton( '#lang_loading' );

	-- Ensure size is correct
	self.button:SizeToContents( );

	-- Give it a little additional space
	-- Task: Create a helper function which returns the largest section of the animation so we can get the size and ensure we set the button to the max possible size
	self.button:SetWidth( self.button:GetWidth( ) + 25 );
end


--
-- Our render panel function
--
function PANEL:Paint( _w, _h )
	-- Get the animation text and let us know if it has advanced
	local _anim, _has_advanced = string.SimpleAnimation( STRING_ANIMATION_DOTS, 'button_loading_dots' );

	-- If the animation text has changed - update the button... If we added enough buffer room it shouldn't need to be resized ( which would look ugly anyway; hence the need for a function to get the largest size and for optimization, check when the animation is created instead of when used )...
	-- OR simple check the first use - which would be too late for this example though... unless we resize to max as it happens then never shrink.
	if ( _has_advanced ) then
		-- Update the text - Note: Assume Set/Get BaseText is used to store text and isn't output or changed with SetText.
		self.button:SetText( self.button:GetBaseText( ) .. _anim );

		-- Invalidate the button as it has changed
		self.button:Invalidate( );

		-- Make sure the panel knows that something has changed within it.
		self:InvalidateLayout( );
	end
end
