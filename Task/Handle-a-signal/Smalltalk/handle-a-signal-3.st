|mySignal|
mySignal := Signal new mayProceed: false.
OperatingSytem operatingSystemSignal: (OperatingSystem signalNamed:'SIGHUP') install: mySignal.
[
   .. do something...
] on: mySignal do:[
   ... handle SIGHUP gracefully...
]
