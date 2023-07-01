>>> import tempfile
>>> invisible = tempfile.TemporaryFile()
>>> invisible.name
'<fdopen>'
>>> visible = tempfile.NamedTemporaryFile()
>>> visible.name
'/tmp/tmpZNfc_s'
>>> visible.close()
>>> invisible.close()
