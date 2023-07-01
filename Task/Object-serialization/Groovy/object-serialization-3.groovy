def is
try {
    is = objectStore.newObjectInputStream(this.class.classLoader)
    is.eachObject { println it }
} catch (e) { throw new Exception(e) } finally { is?.close() }

objectStore.delete()
assert ! objectStore.exists()
