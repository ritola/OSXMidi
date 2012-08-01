#import "Midi.h"
#import "OSXMidi.h"

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_00024_getEndpoints
(JNIEnv *env, jclass c)
{
    @autoreleasepool {
        JavaVector *vector = [[JavaVector alloc] init: env];
        
        ItemCount count = MIDIGetNumberOfSources();
        for (ItemCount i = 0; i < count; i++) {
            MidiIn *midiEndpoint = [[MidiIn alloc] init: env];
            [midiEndpoint setRef: MIDIGetSource(i)];
            [vector addElement: midiEndpoint->object];
        }

        count = MIDIGetNumberOfDestinations();
        for (ItemCount i = 0; i < count; i++) {
            MidiOut *midiEndpoint = [[MidiOut alloc] init: env];
            [midiEndpoint setRef: MIDIGetDestination(i)];
            [vector addElement: midiEndpoint->object];
        }

        jobject result = vector->object;
        return result;
    }
}

JNIEXPORT void JNICALL Java_cx_oneten_osxmidi_OSXMidi_00024_sendMidi
(JNIEnv *env, jclass c, jobject endPoint, jbyteArray bs)
{
    @autoreleasepool {
        MidiOut *midiOut = [[MidiOut alloc] init: env object: endPoint];
        [midiOut sendMidi: bs];
    }
}
