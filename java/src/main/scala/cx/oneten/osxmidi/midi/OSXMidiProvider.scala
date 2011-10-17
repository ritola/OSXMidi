package cx.oneten.osxmidi.midi

import scala.collection.JavaConversions._

import javax.sound.midi.spi.MidiDeviceProvider
import javax.sound.midi.MidiDevice
import javax.sound.midi.MidiDevice.Info

import cx.oneten.osxmidi.OSXMidi
import cx.oneten.osxmidi.jni.MidiEndpoint

class OSXMidiProvider extends MidiDeviceProvider {
  override def getDevice(info: Info): MidiDevice = { null }
  override def getDeviceInfo(): Array[Info] = {
    val o = new OSXMidi
    o.getEndpoints.map(new OSXMidiInfo(_)).toArray
  }
}

class OSXMidiInfo(e: MidiEndpoint)
  extends Info(e.properties.get("name"), e.entity.get.device.get.properties.get("name"), e.properties.get("name"), "1.0") {

}