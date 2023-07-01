--
-- Simple String Animation - Josh 'Acecool' Moser under modified ACL - Free to use, modify and learn from.
--

--[[

	This set of helpers is meant to be called every frame / render.. It can either be used this way and output via means of drawing the text directly, or by updating a panel and invalidating the layout, when the animation changes as a return allows you to do this.

	A few recommendations:

		Alter and add in an advance frame function - then you can have a separate system advance the frame of the unique id and make the clock tell time to the best of its limitations, or make the clock go backwards during an undo action..

		You can set up a direction override so you can make the animation go in reverse and only in reverse for the undo action...

		With the advance frame function you can advance the frame based on user interactions..

		You can also improve the __anim_data table by making a single table within: [ _id ] = { dir = 1, pos = 1, paused = false, and_extend_it = true, cooldown = 0 }

	etc.. etc.. etc...

	I do hope this has been easy to understand and educational.

]]



--
-- Enumeration
-- Here, we are simply setting up variable names with meaning where the value means nothing - the value must be unique for the table. This lets us reference the animation we want without having to remember 0, 1, 2, or some other number which makes code look messy.
--

-- This is for the pipe animation | / ─ \
STRING_ANIMATION_PIPE = 0;

-- This is for the dot animation . .. ... .. and stacked stars
STRING_ANIMATION_DOTS = 1;

-- Stacking stars
STRING_ANIMATION_STAR_DOTS = 2;

-- This is for the clock animation
STRING_ANIMATION_CLOCK = 3;

-- Arrow
STRING_ANIMATION_ARROW = 4;

-- Bird in flight
STRING_ANIMATION_BIRD = 5;

-- Flower
STRING_ANIMATION_FLOWER = 6;

-- Eclipse - From Raku Throbber post author
STRING_ANIMATION_ECLIPSE = 7;

-- Add more... You can also create a function to create enums quickly.. I may include that example at some point in the future.


--
-- Configuration
-- Basic configuration
--

-- The default delay between frames - the function used allows you to override this, as does the table which lets you set up a delay for that particular animation - this is just the default in case a delay has not been set for either location. As this value is only used as a fallback, it is set as local.
local CFG_STRING_ANIMATION_DEFAULT_DELAY = 1 / 8;

-- The animation map which defines each animation, if it ping / pongs ( starts at beginning, animates through to end, animates through to start and repeats ) or not ( animates from start to end and resets ).
-- Note: Count is set to -1 ( can also be 0 ) so that if you are working in an environment with live-update support the table will be recreated and the entries can be recounted ( this is really only needed if you remove local from the declaration, and do X = X or { } to allow re-using a pre-existing element in a live-update supported application.. Otherwise, count can be completely removed from this map and have it generated the first time string.Animate is called )
local MAP_TIME_ANIMATIONS = {
	[ STRING_ANIMATION_DOTS ]			= { anim = { '.', '..', '...' };																																			reversible = true;		delay = 1 / 3;		count = -1;		};
	[ STRING_ANIMATION_PIPE ]			= { anim = { '|', '/', '─', '\\' };																																			reversible = false;		delay = 1 / 3;		count = -1;		};
	[ STRING_ANIMATION_STAR_DOTS ]		= { anim = { '⁎', '⁑', '⁂' };																																				reversible = true;		delay = 1 / 8;		count = -1;		};
	[ STRING_ANIMATION_CLOCK ]			= { anim = { '🕛', '🕧', '🕐', '🕜', '🕑', '🕝', '🕒', '🕞', '🕓', '🕟', '🕔', '🕠', '🕕', '🕖', '🕗', '🕘', '🕙', '🕚', '🕡', '🕢', '🕣', '🕤', '🕥', '🕦' };		reversible = false;		delay = 1 / 8;		count = -1;		};
	[ STRING_ANIMATION_ARROW ]			= { anim = { '⬍', '⬈', '➞', '⬊', '⬍', '⬋', '⬅', '⬉' };																													reversible = false;		delay = 1 / 8;		count = -1;		};
	[ STRING_ANIMATION_BIRD ]			= { anim = { '︷', '︵', '︹', '︺', '︶', '︸' };																															reversible = true;		delay = 1 / 8;		count = -1;		};
	[ STRING_ANIMATION_FLOWER ]			= { anim = { '☘', '❀', '❁' };																																				reversible = true;		delay = 1 / 8;		count = -1;		};
	[ STRING_ANIMATION_ECLIPSE ]		= { anim = { '🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘' };																																				reversible = false;		delay = 1 / 8;		count = -1;		};
};

-- The default animation type if type isn't set, or if the animation doesn't exist in the table...
MAP_TIME_ANIMATIONS.default = MAP_TIME_ANIMATIONS[ STRING_ANIMATION_DOTS ];


--
-- Runtime data - this table structure keeps track of the direction, which frame it is on, etc..
--

-- Animation data - We are extending the string library with an internal table using my notation.
string.__anim_data = {
	-- Runtime animation data
	runtime = {
		-- Cooldown management - we only need time started and duration; from which we can calculate everything else. Another option for this simple system is to simply set the expiry.
		cooldowns = {
			-- default = { started = -1, duration = 0 }

			-- Expiry only variant... So the time which the cooldown expires goes here.
			default = 0;
		};

		-- The current index for a set id... IE: Which character we are currently showing.
		index = {
			default = 1;
		};

		-- The current direction of travel for the animation ( moving forward through animation = 1, or moving backwards = -1 ).
		dir = {
			default = 1;
		};

		-- Whether or not the animation is paused.
		paused = {
			default = false;
		};
	}
};


--
-- Runtime data - this table structure keeps track of the direction, which frame it is on, etc..
--

-- Animation data - We are extending the string library with an internal table using my notation.
string.__anim_data = {
	-- Runtime animation data
	runtime = {
		-- Cooldown management - we only need time started and duration; from which we can calculate everything else. Another option for this simple system is to simply set the expiry.
		cooldowns = {
			-- default = { started = -1, duration = 0 }

			-- Expiry only variant... So the time which the cooldown expires goes here.
			default = 0;
		};

		-- The current index for a set id... IE: Which character we are currently showing.
		index = {
			default = 1;
		};

		-- The current direction of travel for the animation ( moving forward through animation = 1, or moving backwards = -1 ).
		dir = {
			default = 1;
		};

		-- Whether or not the animation is paused.
		paused = {
			default = false;
		};
	}
};


--
--Updates the pause state of the animation
--
function string.SetTextAnimationPauseState( _type, _id, _value )
	string.__anim_data.runtime.paused[ _id || 'default' ] = ( isbool( _value ) && _value || false );
end


--
-- Returns the pause state, or returns false if nil
--
function string.GetTextAnimationPauseState( _type, _id )
	return string.__anim_data.runtime.paused[ _id || 'default' ] || false;
end


--
-- Pauses the animation
--
function string.PauseTextAnimation( _type, _cycle_delay, _id )
	string.SetTextAnimationPauseState( _type, _id, true );
end


--
-- Unpauses the animation
--
function string.UnPauseTextAnimation( _type, _cycle_delay, _id )
	string.SetTextAnimationPauseState( _type, _id, false );
end


--
-- Toggles the pause state of the animation
--
function string.ToggleTextAnimation( _type, _cycle_delay, _id )
	string.SetTextAnimationPauseState( _type, _id, !string.GetTextAnimationPauseState( _type, _id ) )
end


--
-- This keeps track of the animation by setting up the time tracking, checking it, etc..
-- It returns whether or not a cooldown exists. Basic time management. If a cooldown doesn't exist, and the delay argument is assigned, then it will create a new cooldown for that amount of time but it will return false so the frame can advance.
--
function string.HasAnimationCooldown( _id, _delay )
	-- Fetch the animation data table..
	local _data = string.__anim_data.runtime;

	-- Fetch the cooldowns
	local _cooldowns = _data.cooldowns;

	-- Fetch our cooldown, if it exists.. use default if no id given as this can be called outside the scope of the other function...
	local _cooldown = _cooldowns[ _id or 'default' ] or -1;

	-- A helper which references the current time, in seconds, since the epoch. This should have decimal places?
	-- Note: os.time( ) locks you into 1 second intervals although 0 seconds would work though meaning every call would update the frame and become illegible if rendering many frames per second..
	--local _time = os.time( );

	-- This returns the time since Lua / PC started with millisecond precision. Since we don't need any sort of time output, this is perfect to allow animation that isn't restricted to whole second intervals.
	-- If we wanted to, we could also use this in conjunction with os.time( ) to get a more precise output by getting the current time..
	--
	-- There are many different options to do this...
	--
	-- We could use math.fmod( os.cllock( ), 1 ) which returns the decimals of a number / float.
	-- We could math.floor this number and subtract it from itself, then add the remainder ( decimals ) to os.time( ) which would give us more precision in os.time.
	-- Another way is to subtract math.floor of this number from os.time( ) and then add this entire value to os.time value. Either way you end up with the same result - but this option means subtracting against a larger number.
	-- Another option is casting to string, exploding on ., recasting to number and dividing to put back into decimal format.
	-- We could use string matching via Patterns ( similar to RegEx ).
	-- There is also string.sub after finding the index of the decimal.
	--
	-- etc.. etc.. etc...
	--
	-- The best way is usually the simplest. We don't need to tell time - we just need to measure the passage of time, ie delta T. If we needed time, I'd probably use fmod, unless benchmarking showed it costs more than subtracting and adding.
	--
	local _time = os.clock( );

	-- Setup a helper to see if we have the cooldown.. If our cooldown is a larger number than our current time, we haven't passed it yet and it exists.
	local _has_cooldown = _cooldown > _time;

	-- If we do not have a cooldown, but we have a delay assigned, setup a new cooldown
	if ( !_has_cooldown and type( _delay ) == 'number' ) then
		-- Create in the expiry format - time plus delay....
		_cooldowns[ _id ] = _time + _delay;
	end

	-- Return whether or not we have a cooldown; ignoring if we created one this frame.
	return _has_cooldown;
end


--
-- Animations a string based on our registry and registry options - we are extending the default string library. Be careful when doing this and always ensure you aren't overwriting an important function. As string.Animation doesn't exist, we can add it - but if used we must monitor updates so that if it is added to Lua that we either change the name, or use the new function.
--
-- Basic Usage: This is meant to be called every render frame. You can also micro-cache the data as I went ahead and added the second return which tells you when the character was updated for use in elements that invalidate the layout ( and may cause flickering if you invalidate too frequently ), etc.. It can only update the frame characters if it is being called.
--
-- Argument: _type - <Number> - This is the ENUMerated STRING_ANIMATION_* which lets the function know which animation to reference from the MAP_ table.
-- Argument: _id - <String> - This isn't required - defaults to 'default'. If you want to run multiple animations at the same time, use it or you will advance frames at incorrect times for the animation - the cooldown will be set to whichever delay is called.. So it would be possible to have a delay of 0.5 and a delay of .99 and the first frame advance will happen at 0.5 seconds, then 0.99 will trigger. then 1.0 and 1.5 will be skipped.
-- Argument: _cycle_delay_override - <Number> - This is the delay you wish to use for the animation to advance the frame of the current animation. This is optional. By default it uses the MAP_ table delay in the animation table. If no animation is provided in the MAP_ table, or here, then the default CFG_ animation delay will be used.
--
-- RETURNS: _char - <String> - This returns the character( s ) for the current frame of the current animation as a string. You can append them to another string, or just display them.
-- RETURNS: _has_frame_advanced - <Boolean> - Returns true if the character( s ) ha(s/ve) changed since the last time the function was called.
--
function string.SimpleAnimation( _type, _id, _cycle_delay_override )
	--
	-- Notes: An id isn't required - if no id is provided, 'default' will be used. If you try running 2 separate animations with the same name, one will overwrite the other and the wrong frame will be shown. You can update the internal table to make it so each type has its own id if you want. But this example lets you set a unique id period. So you can show one animation with default, be done with it, and flip to another without having to worry about adding overhead by re-using an existing id.
	--

	-- Ensure the type provided is a number... This prevents it from running... or, as I've chosen - we test and if it doesn't work we use our default.
	-- assert( isnumber( _type ), '[ string.Animation ] _type must be a number!' );

	-- Check the type and ensure it is a number. If it isn't or the map address doesn't exist, we use the default which is handled below.
	local _type					= ( ( type( _type ) == 'number' and MAP_TIME_ANIMATIONS[ _type ] ) and _type or nil );

	-- Setup the id to identify this animation as
	local _id					= ( type( _id ) == 'string' and _id or 'default' );

	-- The data
	local _data					= ( MAP_TIME_ANIMATIONS[ _type ] or MAP_TIME_ANIMATIONS.default );

	-- The animation table
	local _anim					= _data.anim;

	-- If we don't know how many elements there are to the animation, count the entries and cache the result so we don't have to do it again.

	if ( !_data.count or _data.count < 1 ) then _data.count = #_data.anim; end

	-- The characters.
	local _count				= _data.count;

	-- If there is nothing to animate - output nothing.
	if ( _count < 1 ) then return ''; end

	-- The animation runtime data table
	local _runtime				= string.__anim_data.runtime;

	-- This is the direction of travel - we use it to multiply against our +1 so it is + ( 1 * dir ) to make it add or subtract.
	local _dir					= _runtime.dir[ _id ] or 1;

	-- The runtime index table for all ids
	local _indexes				= _runtime.index;

	-- The runtime character index table for the id in question - the first character is used by default.
	local _index				= _indexes[ _id ] or 1;

	-- Has the frame advanced?
	local _has_frame_advanced	= false;

	-- Fetch whether or not the animation is paused... -- went ahead and added it.
	local _paused				= string.GetTextAnimationPauseState( _type, _id );

	-- This returns whether or not the cooldown exists, or has expired. It will automatically re-create it so the next frame this will return t rue if the delay is longer than a frame.
	local _has_cooldowm			= string.HasAnimationCooldown( 'string_animation_' .. _id, ( type( _cycle_delay_override ) == 'number' and _cycle_delay_override or ( type( _runtime.delay ) == 'number' and _runtime.delay or CFG_STRING_ANIMATION_DEFAULT_DELAY ) ) );

	-- If the text isn't paused, and there isn't a cooldown ( ie, the delay has expired and we can advance to the next frame ) then continue...
	if ( !_paused and !_has_cooldowm ) then
		-- If we actually have more than 1 character so that we can advance the frame and it not be a waste of time by simply advancing / reverting to the same frame - then we run the logic.... If there is only 1 frame ( why? ) then we skip this logic.
		if ( _count > 1 ) then
			-- Update the reference - this makes it so you can re-use ids with different animations and different count values and it will just wrap around to what it should be.
			_indexes[ _id ] = ( _index + _dir ) % ( _count + 1 );

			-- Debugging, if you want to see it.
			-- print( '[ string.Animation ] Type: ' .. _type .. '; Delay: ' .. _cycle_delay_override .. '; ID: ' .. _id .. '; I: ' .. tostring( _index ) .. '; Char: ' .. tostring( _char ) .. '; Paused: ' .. tostring( _paused ) );

			-- If we are at the limits - decide what to do based on options. This isn't necessary - we could simply use % notation
			if ( _indexes[ _id ] <= 1 or _indexes[ _id ] > _count + 1 ) then
				if ( _data.reversible ) then
					-- ping pong;
					_indexes[ _id ] = ( _indexes[ _id ] == 0 ) and _count - 1 or _indexes[ _id ];

					-- Revert
					_runtime.dir[ _id ] = _dir * -1;
				else
					-- Reset
					_indexes[ _id ] = ( _indexes[ _id ] == 0 ) and 1 or _indexes[ _id ];
				end
			end

			-- Update the _index helper so that our character will be the current instead of having to wait until the next frame.
			_index = _indexes[ _id ] or 1;

			-- The frame has advanced - update the var so we can use it to perform an action if necessary..
			_has_frame_advanced = true;
		end
	end

	-- The frame character( s )
	local _char					= _anim[ _index ] or '';

	-- Return the character( s ) from the current animation frame
	return _char, _has_frame_advanced;
end
