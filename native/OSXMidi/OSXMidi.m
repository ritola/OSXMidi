#import "OSXMidi.h"
#import "Java.h"
#import "Midi.h"

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_getEndpoints
(JNIEnv *env, jclass clazz)
{
    Java *java = [[Java alloc] initWithEnv: env];
    jobject vector = [java newObject: "java/util/Vector" : "()V"];
    
    ItemCount count = MIDIGetNumberOfSources();
    for (ItemCount i = 0; i < count; i++) {
        jobject midiEndpoint = [java newObject: "cx/oneten/osxmidi/jni/MidiEndpoint" : "()V"];
        [java callVoidMethod: vector :"addElement" : "(Ljava/lang/Object;)V", midiEndpoint];

        MIDIEndpointRef source = MIDIGetSource(i);
        [java setLongField: midiEndpoint : "ref" : source];

        CFStringRef name = CreateEndpointName(source, false);
        [java setStringField: midiEndpoint : "name" : name];
        CFRelease(name);        
    }

    count = MIDIGetNumberOfDestinations();
    for (ItemCount i = 0; i < count; i++) {
        jobject midiEndpoint = [java newObject: "cx/oneten/osxmidi/jni/MidiEndpoint" : "()V"];
        [java callVoidMethod: vector :"addElement" : "(Ljava/lang/Object;)V", midiEndpoint];
        
        MIDIEndpointRef destination = MIDIGetDestination(i);
        [java setLongField: midiEndpoint : "ref" : destination];
        
        CFStringRef name = CreateEndpointName(destination, false);
        [java setStringField: midiEndpoint : "name" : name];
        CFRelease(name);        
    }
    
    [java release];
    return vector;
}
