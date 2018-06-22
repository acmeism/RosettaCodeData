data = (
	'ZGF0YSA9ICgKCSc=',
	'JywKCSc=',
	'JwopCnByZWZpeCwgc2VwYXJhdG9yLCBzdWZmaXggPSAoZC5kZWNvZGUoJ2Jhc2U2NCcpIGZvciBkIGluIGRhdGEpCnByaW50IHByZWZpeCArIGRhdGFbMF0gKyBzZXBhcmF0b3IgKyBkYXRhWzFdICsgc2VwYXJhdG9yICsgZGF0YVsyXSArIHN1ZmZpeA=='
)
prefix, separator, suffix = (d.decode('base64') for d in data)
print prefix + data[0] + separator + data[1] + separator + data[2] + suffix
