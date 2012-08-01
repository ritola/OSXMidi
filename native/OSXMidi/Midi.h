#import <CoreMIDI/MIDIServices.h>

#import "Java.h"

@interface MidiObject : JavaObject {
@public
    MIDIObjectRef ref;
    JavaMap *properties;
}
-(MidiObject*) init: (JNIEnv*) e classname: (const char *) c object: (jobject) o;
-(MidiObject*) init: (JNIEnv*) e classname: (const char *) c;
-(void) setRef: (MIDIObjectRef) r;
-(void) updateStringProperty: (CFStringRef) propertyID;
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
@end

@interface MidiEndpoint : MidiObject {
@public
    MidiEntity *entity;
}
-(MidiEndpoint*) init: (JNIEnv*) e classname: (const char *) c;
-(void) setRef: (MIDIObjectRef) r;
@end

@interface MidiIn : MidiEndpoint {}
-(MidiIn*) init: (JNIEnv*) e;
@end
    
@interface MidiOut : MidiEndpoint {}
-(MidiOut*) init: (JNIEnv*) e;
-(MidiOut*) init: (JNIEnv *) e object: (jobject) o;
-(void) sendMidi: (jbyteArray) bs;
@end


static void NotifyProc(const MIDINotification *, void *);
static void ReadProc(const MIDIPacketList *, void *, void *);
