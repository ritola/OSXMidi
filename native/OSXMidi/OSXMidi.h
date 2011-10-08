#import <JavaVM/jni.h>
#import <CoreMIDI/MIDIServices.h>

#import "Java.h"

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_getEndpoints (JNIEnv *, jclass);

@interface MidiObject : JavaObject {
@public
    MIDIObjectRef ref;
    JavaMap *properties;
}
-(MidiObject*) init: (JNIEnv*) e classname: (const char *) c;
-(void) setRef: (MIDIObjectRef) r;
-(void) updateStringProperty: (CFStringRef) propertyID;
-(void) dealloc;
@end

@interface MidiEndpoint : MidiObject {}
-(MidiEndpoint*) init: (JNIEnv*) e;
@end

@interface MidiEntity : MidiObject {}
-(MidiEntity*) init: (JNIEnv*) e;
@end

@interface MidiDevice : MidiObject {}
-(MidiDevice*) init: (JNIEnv*) e;
@end