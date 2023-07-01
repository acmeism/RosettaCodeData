def makeCamera(self) {
    return def camera extends minherit(self, []) {
        to takesPictures() { return true }
    }
}

def makeMobilePhone(self) {
    return def mobilePhone extends minherit(self, []) {
        to makesCalls() { return true }
        to internalMemory() { return 64*1024 }
    }
}

def makeCameraPhone(self) {
    return def cameraPhone extends minherit(self, [
        makeCamera(self),
        makeMobilePhone(self),
    ]) {
        to internalMemory() {
            return super.internalMemory() + 32 * 1024**2
        }
    }
}
