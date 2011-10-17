package cx.oneten.osxmidi.midi

import javax.sound.midi.spi.MidiDeviceProvider
import javax.sound.midi.MidiDevice
import javax.sound.midi.MidiDevice.Info

class OSXMidiProvider extends MidiDeviceProvider {
  override def getDevice(info: Info): MidiDevice = { null }
  override def getDeviceInfo(): Array[Info] = { null }
}