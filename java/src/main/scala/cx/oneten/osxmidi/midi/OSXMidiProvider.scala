package cx.oneten.osxmidi.midi

import java.util.List
import java.util.ArrayList
import javax.sound.midi.spi.MidiDeviceProvider
import javax.sound.midi.MidiDevice
import javax.sound.midi.MidiDevice.Info
import javax.sound.midi.Transmitter
import javax.sound.midi.Receiver
import scala.collection.JavaConversions._

import cx.oneten.osxmidi.OSXMidi
import cx.oneten.osxmidi.jni.MidiEndpoint

class OSXMidiProvider extends MidiDeviceProvider {
  override def isDeviceSupported(info: Info): Boolean = info.isInstanceOf[OSXMidiInfo]

  override def getDevice(info: Info): MidiDevice = info match {
    case i: OSXMidiInfo => new OSXMidiDevice(i)
    case _ => throw new IllegalArgumentException
  }

  override def getDeviceInfo(): Array[Info] = {
    val o = new OSXMidi
    o.getEndpoints.map(e => new OSXMidiInfo(info(e))).toArray
  }

  def info(e: MidiEndpoint) = {
    def name = e.properties.get("name")
    def vendor = e.entity.get.device.get.properties.get("name")
    def description = e.properties.get("name")
    def version = "1.0"
    (name, vendor, description, version)
  }

}

class OSXMidiInfo(i: Tuple4[String, String, String, String]) extends Info(i._1, i._2, i._3, i._4) {
}

class OSXMidiDevice(i: OSXMidiInfo) extends MidiDevice {
  override def getDeviceInfo(): Info = i
  override def getTransmitters(): List[Transmitter] = new ArrayList()
  override def getTransmitter(): Transmitter = null
  override def getReceivers(): List[Receiver] = new ArrayList()
  override def getReceiver(): Receiver = null
  override def getMaxTransmitters: Int = 0
  override def getMaxReceivers: Int = 0
  override def getMicrosecondPosition: Long = 0
  override def isOpen: Boolean = false
  override def open {}
  override def close {}
}