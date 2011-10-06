#import "Midi.h"
#import "OSXMidi.h"

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_getEndpoints
(JNIEnv *env, jclass clazz)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    JavaVector *vector = [[[JavaVector alloc] init: env] autorelease];
    
    ItemCount count = MIDIGetNumberOfSources();
    for (ItemCount i = 0; i < count; i++) {
        MidiEndpoint *midiEndpoint = [[[MidiEndpoint alloc] init: env] autorelease];
        [midiEndpoint setRef: MIDIGetSource(i)];
        [vector addElement: midiEndpoint->object];
    }

    count = MIDIGetNumberOfDestinations();
    for (ItemCount i = 0; i < count; i++) {
        MidiEndpoint *midiEndpoint = [[[MidiEndpoint alloc] init: env] autorelease];
        [midiEndpoint setRef: MIDIGetDestination(i)];
        [vector addElement: midiEndpoint->object];
    }

    jobject result = vector->object;
    [pool release];
    return result;
}

@implementation MidiObject
-(MidiObject*) init: (JNIEnv*) e classname: (const char *) c {
    self = (MidiObject*) [super initWithEnv: e];
    object = [self newObject: c : "()V"];
    return self;
}
@end

@implementation MidiEndpoint
-(MidiEndpoint*) init: (JNIEnv *) e {
    self = (MidiEndpoint*) [super init: e classname: "cx/oneten/osxmidi/jni/MidiEndpoint"];
    properties = [[JavaMap alloc] init: env map: [self getObjectField: "properties" : "Ljava/util/Map;"]];
    return self;
}
-(void) setRef: (MIDIEndpointRef) r {
    ref = r;
    [self setLongField: "ref" : ref];
    CFStringRef value = CreateEndpointName(ref, false);
    [properties put: CFStringToJavaString(env, kMIDIPropertyName) : CFStringToJavaString(env, value)];
    CFRelease(value);
}
-(void) dealloc {
    [properties dealloc];
    [super dealloc];
}
@end

@implementation MidiEntity
-(MidiEntity*) init: (JNIEnv *) e {
    self = (MidiEntity*) [super init: e classname: "cx/oneten/osxmidi/jni/MidiEntity"];
    return self;
}
@end

@implementation MidiDevice
-(MidiDevice*) init: (JNIEnv *) e {
    self = (MidiDevice*) [super init: e classname: "cx/oneten/osxmidi/jni/MidiDevice"];
    return self;
}
@end