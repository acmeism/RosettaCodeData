import zlib, base64

const b64 = """
eNrtVE1rwzAMvedXaKdeRn7ENrb21rHCzmrs1m49K9gOJv9+cko/HBcGg0LHcpOfnq2np0QL
2FuKgBbICDAoeoiKwEc0hqIUgLAxfV0tQJCdhQM7qh68kheswKeBt5ROYetTemYMCC3rii//
WMS3WkhXVyuFAaLT261JuBWwu4iDbvYp1tYzHVS68VEIObwFgaDB0KizuFs38aSdqKv3TgcJ
uPYdn2B1opwIpeKE53qPftxRd88Y6uoVbdPzWxznrQ3ZUi3DudQ/bcELbevqM32iCIrj3IIh
W6plOJf6L6xaajZjzqW/qAsKIvITBGs9Nm3glboZzkVP5l6Y+0bHLnedD0CttIyrpEU5Kv7N
Mz3XkPBc/TSN3yxGiqMiipHRekycK0ZwMhM8jerGC9zuZaoTho3kMKSfJjLaF8v8wLzmXMqM
zJvGew/jnZPzclA08yAkikegDTTUMfzwDXBcwoE="""

proc uncompress*(source: string, destLen: var int): string =
  result = newString(destLen)
  discard uncompress(result.cstring, addr destLen, source.cstring, source.len)

var length = 10_000
echo b64.decode.uncompress length
