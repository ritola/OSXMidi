package cx.oneten.osxmidi

import cx.oneten.osxmidi.jni.MidiEndpoint

object OSXMidi {
  System.loadLibrary("OSXMidi")
  @native def getEndpoints(): java.util.Vector[MidiEndpoint]
  @native def sendMidi(endpoint: MidiEndpoint, bytes: Array[Byte])
}