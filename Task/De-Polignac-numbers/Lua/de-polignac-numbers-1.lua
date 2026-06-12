do  -- Números de De Polignac - traducido del HPPPL

local function ES_PRIMO(n)

  local I
  if n <= 1 then
    return 0  -- No es primo
  end
  if n == 2 then
    return 1  -- 2 es primo
  end
  if n % 2 == 0 then
    return 0  -- No es primo
  end
  for I = 3, math.sqrt(n), 2 do
    if n % I == 0 then
      return 0 -- No es primo
    end
  end
  return 1  -- Es primo
end

local function esDePolignac(x)

  if x<=0 or (x % 2)==0 then
    return 0
  end
  local p
  local potencia
  local n
  for n = 0, 30 do
    potencia=math.floor(2^n)
    if potencia>x then
      return 1
    else
      p=x-potencia
      if ES_PRIMO(p) ~= 0 then return 0
      end
    end
  end
  return 1
end

print()
local contador=0
local numero=1
local resultados50={}
while contador<50 do
  if esDePolignac(numero) ~= 0 then
    contador=contador + 1
    resultados50[contador]=numero
  end
  numero=numero + 2
end

local salida=""
print("Primeros 50 números de De Polignac:")
for I = 1, 50 do
  salida=salida..tostring(resultados50[I]).." "
  if I % 5 == 0 then salida=salida .. string.char(10)
  end
end
print(salida)

local contador=0
local numero=1
while contador<10000 do
  if esDePolignac(numero) ~= 0 then
    contador=contador + 1
    if contador==1000 then
      print("El número de De Polignac #1000 es "..numero)
    end
    if contador==10000 then
      print("El número de De Polignac #10000 es "..numero)
    end
  end
  numero=numero + 2
end
print("<fin>")
end
