package cx.oneten.osxmidi.jni

class MidiEndpoint {
  var ref: Long = 0
  var name: String = ""
  override def toString = "[MidiEndpoint: ref=" + ref + " name=" + name + "]"
}