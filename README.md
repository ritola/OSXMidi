# Java MIDI driver for OS X

Apple OS X can not send MIDI system exclusive commands from Java. Workaround for this is to use a dedicated driver on /Library/Java/Extensions folder. This project is about to provide this driver.

## Current status

Messages are sent, but not received yet. However, you can do following depending on your role:

* As an end user: Wait
* As a developer: Fork and make a pull request. [See developer info](https://github.com/ritola/OSXMidi/blob/master/DEVELOPING.md).

