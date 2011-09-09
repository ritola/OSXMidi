# Java MIDI drivers for OS X

Apple OS X can not send MIDI system exclusive commands from Java. Workaround for this is to use a dedicated driver on /Library/Java/Extensions folder. This project is about to provide this driver.

## Current status

No message is sent or received yet. Just basic communication between Java and CoreMidi is available. However, you can do following depending on your role:

* As an end user: Wait
* As a developer: Fork and make a pull request

## Developing

You'll need:

* OS X Lion
* Midi devices
* Some tools
    * Xcode 4.1
    * IntelliJ Idea, Community Edition is just fine
    * Terminal

### Java drivers without Java?

This may be a disappointment, but the drivers are made by Scala programming language. It's a language running on Java Virtual Machine, but it is more elegant. You should learn it too.

