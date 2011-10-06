## Basics

Drivers are being made using Scala programming language. Scala communicates to CoreMidi through JNI library written in Objective C.

### Tools

You'll need:

* OS X Lion
* Midi devices
* Some tools
    * Xcode 4.1
    * IntelliJ Idea, Community Edition is just fine
    * Terminal

## To do

We need help on the following:

### New functionality

You can pick any of the following

* Enumerate available interfaces
    * Map name property for endpoint, entity and device) to Java
    * Link endpoints to entities and entities to devices
    * Map those in Scala to [MidiDevice](http://download.oracle.com/javase/1.5.0/docs/api/javax/sound/midi/MidiDevice.Info.html)
    * Make a service
* Open and Close an interface
* Send and receive MIDI messages

