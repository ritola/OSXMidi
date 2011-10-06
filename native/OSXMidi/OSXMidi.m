#import "Midi.h"
#import "OSXMidi.h"

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_getEndpoints
(JNIEnv *env, jclass clazz)
{
    Java *java = [[Java alloc] initWithEnv: env];
    JavaVector *vector = [[JavaVector alloc] init: env];
    
    ItemCount count = MIDIGetNumberOfSources();
    for (ItemCount i = 0; i < count; i++) {
        MidiEndpoint *midiEndpoint = [[MidiEndpoint alloc] initEndpoint: env];
        [vector addElement: [midiEndpoint getObject]];

        MIDIEndpointRef source = MIDIGetSource(i);
        [midiEndpoint setLongField: "ref" : source];
        
        JavaMap *properties = [[JavaMap alloc] init: env map: [midiEndpoint getObjectField: "properties" : "Ljava/util/Map;"]];
        CFStringRef value = CreateEndpointName(source, false);
        [properties put: CFStringToJavaString(env, kMIDIPropertyName) : CFStringToJavaString(env, value)];
        CFRelease(value);
        [properties release];
        [midiEndpoint release];
    }

    count = MIDIGetNumberOfDestinations();
    for (ItemCount i = 0; i < count; i++) {
        MidiEndpoint *midiEndpoint = [[MidiEndpoint alloc] initEndpoint: env];
        [vector addElement: [midiEndpoint getObject]];
        
        MIDIEndpointRef destination = MIDIGetDestination(i);
        [midiEndpoint setLongField: "ref" : destination];
        
        JavaMap *properties = [[JavaMap alloc] init: env map: [midiEndpoint getObjectField: "properties" : "Ljava/util/Map;"]];
        CFStringRef value = CreateEndpointName(destination, false);
        [properties put: CFStringToJavaString(env, kMIDIPropertyName) : CFStringToJavaString(env, value)];
        CFRelease(value);
        [properties release];
        [midiEndpoint release];
    }

    [java release];
    jobject result = vector.getObject;
    [vector release];
    return result;
}

@implementation MidiEndpoint
-(MidiEndpoint*) initEndpoint: (JNIEnv *) e {
    self = (MidiEndpoint*) [super initWithEnv: e];
    [self setObject: [self newObject: "cx/oneten/osxmidi/jni/MidiEndpoint" : "()V"]];
    return self;
}

@end