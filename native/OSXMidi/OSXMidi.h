#import <JavaVM/jni.h>
#import <CoreMIDI/MIDIServices.h>

#import "Java.h"

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_getEndpoints (JNIEnv *, jclass);

@interface MidiEndpoint : JavaObject {}
-(MidiEndpoint*) initEndpoint: (JNIEnv*) env;
@end