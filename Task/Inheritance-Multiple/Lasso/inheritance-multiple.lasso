define trait_camera => trait {
	require zoomfactor

	provide has_zoom() => {
		return .zoomfactor > 0
	}

}

define trait_mobilephone => trait {
	require brand

	provide is_smart() => {
		return .brand == 'Apple'
	}

}

define cameraphone => type {

	trait {
		import trait_camera, trait_mobilephone
	}

	data public zoomfactor::integer = 0,
		public brand::string

}

local(mydevice = cameraphone)

#mydevice -> brand = 'Apple'
#mydevice -> zoomfactor = 0

#mydevice -> has_zoom
'<br />'
#mydevice -> is_smart
