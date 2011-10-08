#import <CoreMIDI/MIDIServices.h>

#import "Java.h"

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

@interface MidiDevice : MidiObject {}
-(MidiDevice*) init: (JNIEnv*) e;
@end

@interface MidiEntity : MidiObject {
@public
    MidiDevice *device;
}
-(MidiEntity*) init: (JNIEnv *) e;
-(void) setRef: (MIDIObjectRef) r;
-(void) dealloc;
@end

@interface MidiEndpoint : MidiObject {
@public
    MidiEntity *entity;
}
-(MidiEndpoint*) init: (JNIEnv*) e;
-(void) setRef: (MIDIObjectRef) r;
-(void) dealloc;
@end
