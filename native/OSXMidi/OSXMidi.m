#import "Midi.h"
#import "OSXMidi.h"

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_00024_getEndpoints
(JNIEnv *env, jclass clazz)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    JavaVector *vector = [[[JavaVector alloc] init: env] autorelease];
    
    ItemCount count = MIDIGetNumberOfSources();
    for (ItemCount i = 0; i < count; i++) {
        MidiIn *midiEndpoint = [[[MidiIn alloc] init: env] autorelease];
        [midiEndpoint setRef: MIDIGetSource(i)];
        [vector addElement: midiEndpoint->object];
    }

    count = MIDIGetNumberOfDestinations();
    for (ItemCount i = 0; i < count; i++) {
        MidiOut *midiEndpoint = [[[MidiOut alloc] init: env] autorelease];
        [midiEndpoint setRef: MIDIGetDestination(i)];
        [vector addElement: midiEndpoint->object];
    }

    jobject result = vector->object;
    [pool release];
    return result;
}
