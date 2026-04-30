const Status = {
  OFF: 'OFF',
  ON: 'ON'
};

class RS232Pins9 {
  constructor() {
    this.Pin = {
      carrierDetect: { pinNumber: 1, status: Status.OFF, name: 'carrierDetect' },
      receivedData: { pinNumber: 2, status: Status.OFF, name: 'receivedData' },
      transmittedData: { pinNumber: 3, status: Status.OFF, name: 'transmittedData' },
      dataTerminalReady: { pinNumber: 4, status: Status.OFF, name: 'dataTerminalReady' },
      signalGround: { pinNumber: 5, status: Status.OFF, name: 'signalGround' },
      dataSetReady: { pinNumber: 6, status: Status.OFF, name: 'dataSetReady' },
      requestToSend: { pinNumber: 7, status: Status.OFF, name: 'requestToSend' },
      clearToSend: { pinNumber: 8, status: Status.OFF, name: 'clearToSend' },
      ringIndicator: { pinNumber: 9, status: Status.OFF, name: 'ringIndicator' }
    };
  }

  getPin(pinNumber) {
    for (const key in this.Pin) {
      if (this.Pin[key].pinNumber === pinNumber) {
        return this.Pin[key].status;
      }
    }
    throw new Error(`Unknown pin number: ${pinNumber}`);
  }

  getPinByName(name) {
    for (const key in this.Pin) {
      if (this.Pin[key].name === name) {
        return this.Pin[key].status;
      }
    }
    throw new Error(`Unknown pin name: ${name}`);
  }

  setPin(pinNumber, status) {
    for (const key in this.Pin) {
      if (this.Pin[key].pinNumber === pinNumber) {
        this.Pin[key].status = status;
      }
    }
  }

  setPinByName(name, status) {
    for (const key in this.Pin) {
      if (this.Pin[key].name === name) {
        this.Pin[key].status = status;
      }
    }
  }

  displayPinStatus() {
    for (const key in this.Pin) {
      console.log(`${this.Pin[key].name.padEnd(29)} has status ${this.Pin[key].status}`);
    }
  }
}

// Example usage:
const plug = new RS232Pins9();
console.log(plug.getPinByName('receivedData'));
plug.setPin(2, Status.ON);
console.log(plug.getPinByName('receivedData'));
plug.setPinByName('signalGround', Status.ON);
plug.displayPinStatus();
