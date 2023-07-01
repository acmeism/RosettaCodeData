module TempConvert

  FROM_TEMP_SCALE_TO_K =
  {'kelvin'     => lambda{|t| t},
   'celsius'    => lambda{|t| t + 273.15},
   'fahrenheit' => lambda{|t| (t + 459.67) * 5/9.0},
   'rankine'    => lambda{|t| t * 5/9.0},
   'delisle'    => lambda{|t| 373.15 - t * 2/3.0},
   'newton'     => lambda{|t| t * 100/33.0 + 273.15},
   'reaumur'    => lambda{|t| t * 5/4.0 + 273.15},
   'roemer'     => lambda{|t| (t - 7.5) * 40/21.0 + 273.15}}

  TO_TEMP_SCALE_FROM_K =
  {'kelvin'     => lambda{|t| t},
   'celsius'    => lambda{|t| t - 273.15},
   'fahrenheit' => lambda{|t| t * 9/5.0 - 459.67},
   'rankine'    => lambda{|t| t * 9/5.0},
   'delisle'    => lambda{|t| (373.15 - t) * 3/2.0},
   'newton'     => lambda{|t| (t - 273.15) * 33/100.0},
   'reaumur'    => lambda{|t| (t - 273.15) * 4/5.0},
   'roemer'     => lambda{|t| (t - 273.15) * 21/40.0 + 7.5}}

  SUPPORTED_SCALES = FROM_TEMP_SCALE_TO_K.keys.join('|')

  def self.method_missing(meth, *args, &block)
    if valid_temperature_conversion?(meth) then
      convert_temperature(meth, *args)
    else
      super
    end
  end

  def self.respond_to_missing?(meth, include_private = false)
    valid_temperature_conversion?(meth) || super
  end

  def self.valid_temperature_conversion?(meth)
    !!(meth.to_s =~ /(#{SUPPORTED_SCALES})_to_(#{SUPPORTED_SCALES})/)
  end

  def self.convert_temperature(meth, temp)
    from_scale, to_scale = meth.to_s.split("_to_")
    return temp.to_f if from_scale == to_scale # no kelvin roundtrip
    TO_TEMP_SCALE_FROM_K[to_scale].call(FROM_TEMP_SCALE_TO_K[from_scale].call(temp)).round(2)
  end

end
