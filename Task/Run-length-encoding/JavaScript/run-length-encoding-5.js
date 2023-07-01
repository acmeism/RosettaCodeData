const rlEncode = (s: string) => s.match(/(.)\1*/g).reduce((result,char) => result+char.length+char[0],"")
const rlValidate = (s: string) => /^(\d+\D)+$/.test(s)
const rlDecode = (s: string) => rlValidate(s) ? s.match(/(\d[a-z\s])\1*/ig).reduce((res,p) => res+p[p.length-1].repeat(parseInt(p)),"") : Error("Invalid rl")
