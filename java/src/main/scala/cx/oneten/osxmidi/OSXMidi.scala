package cx.oneten.osxmidi

class OSXMidi {
  System.loadLibrary("OSXMidi")
  @native def getOneTen(): Int
}