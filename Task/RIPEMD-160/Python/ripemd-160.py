Python 3.3.0 (v3.3.0:bd8afb90ebf2, Sep 29 2012, 10:57:17) [MSC v.1600 64 bit (AMD64)] on win32
Type "copyright", "credits" or "license()" for more information.
>>> import hashlib
>>> h = hashlib.new('ripemd160')
>>> h.update(b"Rosetta Code")
>>> h.hexdigest()
'b3be159860842cebaa7174c8fff0aa9e50a5199f'
>>>
