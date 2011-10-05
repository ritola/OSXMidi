package cx.oneten.osxmidi.jni

class MidiObject {
  var ref: Long = 0
  var properties: Map[String, String] = new HashMap
  override def toString = "[MidiObject: ref=" + ref + " properties=" + properties + "]"
}

class MidiEndpoint extends MidiObject {
  entity: MidiEntity
}

class MidiEntity extends MidiObject {
  device: MidiDevice
}

class MidiDevice extends MidiObject {

}