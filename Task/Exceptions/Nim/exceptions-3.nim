try:
  spam()
except SillyError:
  echo "Got SillyError with message: ", getCurrentExceptionMsg()
except:
  echo "Got another exception"
finally:
  echo "Finally"
