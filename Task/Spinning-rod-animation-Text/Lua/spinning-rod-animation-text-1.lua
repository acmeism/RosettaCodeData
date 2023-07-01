--
-- Simple String Animation - semi-hard-coded variant - you can alter the chars table - update the count and run it...
--

-- The basic animation runtime controller. This is where you assign the active animation ( you could create a simple function to replace the animation table and nil count, index and expiry to extend this system to allow multiple animations -
--	and since you can replace after a previous has been output, it would appear as though you were running different animations at the same time - that wouldn't be async compatible though )...
-- So you can either activate the animation you want permanently, or create a simple function to update the animation table and reset the control variables... ie: ( function string.SetBasicAnimation( _tab_of_chars ) string.__basic_anim_runtime.anim = _tab_of_chars; string.__basic_anim_runtime.index = nil; string.__basic_anim_runtime.count = nil; string.__basic_anim_runtime.expiry = nil; end )
string.__basic_anim_runtime = {
	-- The animation - can not ping pong... requires full sequence. Resets to first after full sequence. Dots animation.. Requires center segment because of ping / pong
	anim = { '.', '..', '...', '..' };

	-- Pipes animation - This performs a complete rotation, no need to add extra segments.
	-- anim = { '|', '/', '─', '\\' };

	-- Stars - This is reversible so requires the center segments..
	-- anim = { '⁎', '⁑', '⁂', '⁑' };

	-- Clock - This still needs to be ordered...
	-- anim = { '🕛', '🕧', '🕐', '🕜', '🕑', '🕝', '🕒', '🕞', '🕓', '🕟', '🕔', '🕠', '🕕', '🕖', '🕗', '🕘', '🕙', '🕚', '🕡', '🕢', '🕣', '🕤', '🕥', '🕦' };

	-- Arrows - This does a complete circle and doesn't need to reverse
	-- anim = { '⬍', '⬈', '➞', '⬊', '⬍', '⬋', '⬅', '⬉' };

	-- Bird Flying - this is reversible so it requires all.. 1 2 3 4 5 6 5 4 3 2
	-- anim = { '︷', '︵', '︹', '︺', '︶', '︸', '︶', '︺', '︹', '︵' };

	-- Plants - Set as reversible, requires all..
	-- anim = { '☘', '❀', '❁', '❀' };

	-- Eclipse - From Raku Throbber post author
	-- anim = { '🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘' };
};


--
-- The basic animator function - accepts a numerical delay and a boolean backwards switch.. It only accepts a single animation from the helper local table above..
--
-- Argument - _delay - <Number> - Accepts a time, in seconds with fraction support, that designates how long a frame should last. Optional. If no number given, it uses the default value of 1 / 8 seconds.
-- Argument - _play_backwards - <Boolean> - Toggles whether or not the animation plays backwards or forwards. Default is forwards. Optional.
--
-- RETURN: <String> - Character( s ) of the current animation frame - if the frame is invalid, it returns an empty string.
-- RETURN: <Boolean> - Has Advanced Frame Controller - set to true if this call resulted in a new frame / index being assigned with new character( s )
--
function string.BasicAnimation( _delay, _play_backwards )
	-- Setup delay - make sure it is a number and Reference our runtime var
	local _delay = ( ( type( _delay ) == 'number' ) and _delay or 1 / 8 ), string.__basic_anim_runtime, os.clock( );

	-- cache our count so we count once per refresh.
	_data.count = ( type( _data.count ) == 'number' ) and _data.count or #_data.anim;

	-- Setup our helpers...
	local _expiry, _index, _chars, _count, _has_advanced_frame = _data.expiry, ( _data.index or ( _play_backwards and _data.count or 1 ) ), _data.anim, _data.count, false;

	-- If expiry has occurred, advance... Expiry can be nil the first call, this is ok because it will just use the first character - or the last if playing backwards.
	if ( _expiry and _expiry < _time ) then
		-- Advance..
		_index, _has_advanced_frame = ( ( _index + ( 1 * ( _play_backwards and -1 or 1 ) ) ) % ( _count + 1 ) ), true;

		-- If 0, add 1 otherwise keep the same.
		_index = _index < 1 and ( _play_backwards and _count or 1 ) or _index;

		-- Update the index
		_data.index = _index;
	end

	-- Update the trackers and output the char. -- Note: This is best done in the loop, but since we are checking the expiry above I decided to integrate it here.
	_data.expiry = ( not _data.expiry or _has_advanced_frame ) and _time + _delay or _data.expiry;

	-- Return the character at the index or nothing.
	return _chars[ _index ] or '', _has_advanced_frame;
end


--
-- Helper / OPTIONAL FUNCTION - Updates the animation and resets the controlling variables
--
-- Argument: _tab - <Table> - This is the table containing the animation characters... ie: { '.', '..', '...', '..' } would be a valid entry. Requires at least 2 entries.
--
function string.SetBasicAnimation( _tab )
	-- Prevent non tables, empty tables, or tables with only 1 entry.
	if not ( type( _tab ) == 'table' and #_tab > 1 ) then return error( 'Can not update basic animation without argument #1 as a table, with at least 2 entries...' ); end

	-- Helper
	local _data = string.__basic_anim_runtime;

	-- Update the animation table and Clear the controllers...
	_data.anim, _data.count, _data.index, _data.expiry = _tab, nil, nil, nil;
end
