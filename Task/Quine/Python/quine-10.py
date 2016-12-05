a = 'YSA9ICcnCmIgPSBhLmRlY29kZSgnYmFzZTY0JykKcHJpbnQgYls6NV0rYStiWzU6XQ=='
b = a.decode('base64')
print b[:5]+a+b[5:]
