package cx.oneten.osxmidi.midi

import java.util.List
import java.util.ArrayList
import javax.sound.midi.spi.MidiDeviceProvider
import javax.sound.midi.MidiDevice
import javax.sound.midi.MidiDevice.Info
import javax.sound.midi.Transmitter
import javax.sound.midi.Receiver
import scala.collection.JavaConversions._
import scala.util.control.Exception.allCatch

import cx.oneten.osxmidi.OSXMidi
import cx.oneten.osxmidi.jni.{MidiIn, MidiOut, MidiEndpoint}

class OSXMidiProvider extends MidiDeviceProvider {
  override def isDeviceSupported(info: Info): Boolean = info.isInstanceOf[OSXMidiInfo]

  override def getDevice(info: Info): MidiDevice = info match {
    case i: OSXMidiInfo => i.endpoint match {
      case _: MidiIn  => new OSXMidiInputDevice(i)
      case _: MidiOut => new OSXMidiOutputDevice(i)
      case _ => throw new IllegalArgumentException
    }
    case _ => throw new IllegalArgumentException
  }

  override def getDeviceInfo(): Array[Info] = {
    OSXMidi.getEndpoints.map(new OSXMidiInfo(_)).toArray
  }

}

object EndpointInfo {
  implicit def endpoint2info(e: MidiEndpoint): EndpointInfo = new EndpointInfo(e)
}

class EndpointInfo(e: MidiEndpoint) {
  def name = allCatch.opt { e.properties.get("name") }.getOrElse("OSX Midi Endpoint")
  def vendor = allCatch.opt { e.entity.get.device.get.properties.get("name") }.getOrElse(name)
  def description = name
  def version = "1.0"
}

import EndpointInfo._

case class OSXMidiInfo(endpoint: MidiEndpoint)
  extends Info(endpoint.name, endpoint.vendor, endpoint.description, endpoint.version) {
}

abstract case class OSXMidiDevice(info: OSXMidiInfo) extends MidiDevice {
  var opened = false
  override def getDeviceInfo: Info = info
  override def getTransmitters: List[Transmitter] = Nil
  override def getTransmitter: Transmitter = null
  override def getReceivers: List[Receiver] = Nil
  override def getReceiver: Receiver = null
  override def getMaxTransmitters: Int = 0
  override def getMaxReceivers: Int = 0
  override def getMicrosecondPosition: Long = 0
  override def isOpen: Boolean = opened
  override def open { opened = true }
  override def close { opened = false }
}

class OSXMidiInputDevice(i: OSXMidiInfo) extends OSXMidiDevice(i) {
  override def getMaxTransmitters: Int = -1
  override def getTransmitters: List[Transmitter] = getTransmitter() :: Nil
  override def getTransmitter: Transmitter = new OSXMidiTransmitter(this)
}

class OSXMidiOutputDevice(i: OSXMidiInfo) extends OSXMidiDevice(i) {
  override def getMaxReceivers: Int = -1
  override def getReceivers: List[Receiver] = getReceiver() :: Nil
  override def getReceiver: Receiver = new OSXMidiReceiver(this)
}

class OSXMidiReceiver(d: OSXMidiDevice) extends Receiver {
  import javax.sound.midi.MidiMessage
  override def close {}
  override def send(message: MidiMessage, timeStamp: Long) {
    OSXMidi.sendMidi(d.info.endpoint, message.getMessage())
  }
}

class OSXMidiTransmitter(d: OSXMidiDevice) extends Transmitter {
  var receiver: Receiver = null
  override def close {}
  override def getReceiver: Receiver = receiver
  override def setReceiver(r: Receiver) { receiver = r }
}
