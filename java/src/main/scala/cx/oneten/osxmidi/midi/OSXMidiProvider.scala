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
    case i: OSXMidiInfo => new OSXMidiDevice(i)
    case _ => throw new IllegalArgumentException
  }

  override def getDeviceInfo(): Array[Info] = {
    val o = new OSXMidi
    o.getEndpoints.map(new OSXMidiInfo(_)).toArray
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

class OSXMidiDevice(i: OSXMidiInfo) extends MidiDevice {
  override def getDeviceInfo(): Info = i
  override def getTransmitters(): List[Transmitter] = new ArrayList()
  override def getTransmitter(): Transmitter = null
  override def getReceivers(): List[Receiver] = new ArrayList()
  override def getReceiver(): Receiver = null
  override def getMaxTransmitters: Int = if (i.endpoint.isInstanceOf[MidiIn]) -1 else 0
  override def getMaxReceivers: Int = if (i.endpoint.isInstanceOf[MidiOut]) -1 else 0
  override def getMicrosecondPosition: Long = 0
  override def isOpen: Boolean = false
  override def open {}
  override def close {}
}
