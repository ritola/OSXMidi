#import <JavaVM/jni.h>
#import <CoreMIDI/MIDIServices.h>

CFStringRef CreateEndpointName(MIDIEndpointRef, bool);
jstring CFStringToJavaString(JNIEnv *, CFStringRef);

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_getEndpoints (JNIEnv *, jclass);

