#import <JavaVM/jni.h>
#import <CoreMIDI/MIDIServices.h>

#import "Java.h"

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_getEndpoints (JNIEnv *, jclass);

@interface MidiObject : JavaObject {}
-(MidiObject*) init: (JNIEnv*) e classname: (const char *) c;
@end

@interface MidiEndpoint : MidiObject {
@public
    MIDIEndpointRef ref;
    JavaMap *properties;
}
-(MidiEndpoint*) init: (JNIEnv*) e;
-(void) setRef: (MIDIEndpointRef) r;
-(void) updateStringProperty: (CFStringRef) propertyID;
-(void) dealloc;
@end

@interface MidiEntity : MidiObject {}
-(MidiEntity*) init: (JNIEnv*) e;
@end

@interface MidiDevice : MidiObject {}
-(MidiDevice*) init: (JNIEnv*) e;
@end