# Convert a quarter-imaginary base value (as a string) into a base 10 Gaussian integer.

def base2i_decode(qi)
  return 0 if qi == '0'
  md = qi.match(/^(?<int>[0-3]+)(?:\.(?<frc>[0-3]+))?$/)
  raise 'ill-formed quarter-imaginary base value' if !md
  ls_pow = md[:frc] ? -(md[:frc].length) : 0
  value = 0
  (md[:int] + (md[:frc] ? md[:frc] : '')).reverse.each_char.with_index do |dig, inx|
    value += dig.to_i * (2i)**(inx + ls_pow)
  end
  return value
end

# Convert a base 10 Gaussian integer into a quarter-imaginary base value (as a string).

def base2i_encode(gi)
  odd = gi.imag.to_i.odd?
  frac = (gi.imag.to_i != 0)
  real = gi.real.to_i
  imag = (gi.imag.to_i + 1) / 2
  value = ''
  phase_real = true
  while (real != 0) || (imag != 0)
    if phase_real
      real, rem = real.divmod(4)
      real = -real
    else
      imag, rem = imag.divmod(4)
      imag = -imag
    end
    value.prepend(rem.to_s)
    phase_real = !phase_real
  end
  value = '0' if value == ''
  value.concat(odd ? '.2' : '.0') if frac
  return value
end
