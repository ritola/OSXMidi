#import "Midi.h"
#import "OSXMidi.h"

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_getEndpoints
(JNIEnv *env, jclass clazz)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    JavaVector *vector = [[[JavaVector alloc] init: env] autorelease];
    
    ItemCount count = MIDIGetNumberOfSources();
    for (ItemCount i = 0; i < count; i++) {
        MidiEndpoint *midiEndpoint = [[[MidiEndpoint alloc] initEndpoint: env] autorelease];
        [vector addElement: midiEndpoint->object];

        MIDIEndpointRef source = MIDIGetSource(i);
        [midiEndpoint setLongField: "ref" : source];
        
        JavaMap *properties = [[[JavaMap alloc] init: env map: [midiEndpoint getObjectField: "properties" : "Ljava/util/Map;"]] autorelease];
        CFStringRef value = CreateEndpointName(source, false);
        [properties put: CFStringToJavaString(env, kMIDIPropertyName) : CFStringToJavaString(env, value)];
        CFRelease(value);
    }

    count = MIDIGetNumberOfDestinations();
    for (ItemCount i = 0; i < count; i++) {
        MidiEndpoint *midiEndpoint = [[[MidiEndpoint alloc] initEndpoint: env] autorelease];
        [vector addElement: midiEndpoint->object];
        
        MIDIEndpointRef destination = MIDIGetDestination(i);
        [midiEndpoint setLongField: "ref" : destination];
        
        JavaMap *properties = [[[JavaMap alloc] init: env map: [midiEndpoint getObjectField: "properties" : "Ljava/util/Map;"]] autorelease];
        CFStringRef value = CreateEndpointName(destination, false);
        [properties put: CFStringToJavaString(env, kMIDIPropertyName) : CFStringToJavaString(env, value)];
        CFRelease(value);
    }

    jobject result = vector->object;
    [pool release];
    return result;
}

@implementation MidiEndpoint
-(MidiEndpoint*) initEndpoint: (JNIEnv *) e {
    self = (MidiEndpoint*) [super initWithEnv: e];
    object = [self newObject: "cx/oneten/osxmidi/jni/MidiEndpoint" : "()V"];
    return self;
}
@end