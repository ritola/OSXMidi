package cx.oneten.osxmidi.jni

import java.util.{Map, HashMap}

class MidiObject {
  var ref: Long = 0
  val properties: Map[String, String] = new HashMap
  override def toString = "[MidiObject: ref=" + ref + " properties=" + properties + "]"
}

class MidiEndpoint extends MidiObject {
  var entity: Option[MidiEntity] = None
  def setEntity(e: MidiEntity) { entity = Option(e) }
}

class MidiEntity extends MidiObject {
  var device: Option[MidiDevice] = None
  def setDevice(d: MidiDevice) { device = Option(d) }
}

class MidiDevice extends MidiObject {

}