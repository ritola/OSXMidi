# Java MIDI drivers for OS X

Apple OS X can not send MIDI system exclusive command from Java. Workaround for this is to use dedicated driver on /Library/Java/Extensions folder. This project is about to provide these drivers.

## Java drivers without Java?

This may be a disappointment, but the drivers are made by Scala programming language. It's a language running on Java Virtual Machine, but it is more elegant. You should learn it too.

## Current status

No message is sent or received yet. Just basic communication between Java and CoreMidi is available. If you are an end-user, you can not do anything with this yet.

