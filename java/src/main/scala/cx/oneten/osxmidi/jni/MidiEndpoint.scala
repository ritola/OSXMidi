package cx.oneten.osxmidi.jni

import java.util.{Map, HashMap}

class MidiObject {
  var ref: Long = 0
  val properties: Map[String, String] = new HashMap
  override def toString = "[MidiObject: ref=" + ref + " properties=" + properties + "]"
}

class MidiIn extends MidiEndpoint
class MidiOut extends MidiEndpoint

class MidiEndpoint extends MidiObject {
  var entity: Option[MidiEntity] = None
  def setEntity(e: MidiEntity) { entity = Option(e) }
  override def toString = ("[MidiEndpoint: ref=" + ref + " properties=" + properties +
    " entity=" + entity + "]")
}

class MidiEntity extends MidiObject {
  var device: Option[MidiDevice] = None
  def setDevice(d: MidiDevice) { device = Option(d) }
  override def toString = ("[MidiDevice: ref=" + ref + " properties=" + properties +
    " device=" + device + "]")
}

class MidiDevice extends MidiObject {

}