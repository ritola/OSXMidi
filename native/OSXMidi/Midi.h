#import <CoreMIDI/MIDIServices.h>

#import "Java.h"

CFStringRef CreateEndpointName(MIDIEndpointRef, bool);

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