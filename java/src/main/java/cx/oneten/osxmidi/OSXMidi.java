package cx.oneten.osxmidi;

import java.util.*;

public class OSXMidi {
  public native int getOneTen();

  static {
    System.loadLibrary("OSXMidi");
  }
}