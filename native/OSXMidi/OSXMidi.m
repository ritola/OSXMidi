#import "OSXMidi.h"
#import "Java.h"
#import "Midi.h"

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_getEndpoints
(JNIEnv *env, jclass clazz)
{
    Java *java = [[Java alloc] initWithEnv: env];
    
    jobject vector = [java newObject: "java/util/Vector" : "()V"];
    
    jclass endpointClass = [java findClass: "cx/oneten/osxmidi/jni/MidiEndpoint"];

    ItemCount count = MIDIGetNumberOfSources();
    for (ItemCount i = 0; i < count; i++) {
        jobject midiEndpoint = [java newObject: "cx/oneten/osxmidi/jni/MidiEndpoint" : "()V"];
        [java callVoidMethod: vector :"addElement" : "(Ljava/lang/Object;)V", midiEndpoint];

        MIDIEndpointRef destination = MIDIGetSource(i);
        (*env)->SetLongField(env, midiEndpoint, (*env)->GetFieldID(env, endpointClass, "ref", "J"), destination);

        CFStringRef name = CreateEndpointName(destination, false);
        jstring javaName = CFStringToJavaString(env, name);
        (*env)->SetObjectField(env, midiEndpoint, (*env)->GetFieldID(env, endpointClass, "name", "Ljava/lang/String;"), 
                            javaName);
        CFRelease(name);        
    }

    count = MIDIGetNumberOfDestinations();
    for (ItemCount i = 0; i < count; i++) {
        jobject midiEndpoint = [java newObject: "cx/oneten/osxmidi/jni/MidiEndpoint" : "()V"];
        [java callVoidMethod: vector :"addElement" : "(Ljava/lang/Object;)V", midiEndpoint];
        
        MIDIEndpointRef destination = MIDIGetDestination(i);
        (*env)->SetLongField(env, midiEndpoint, (*env)->GetFieldID(env, endpointClass, "ref", "J"), destination);
        
        CFStringRef name = CreateEndpointName(destination, false);
        jstring javaName = CFStringToJavaString(env, name);
        (*env)->SetObjectField(env, midiEndpoint, (*env)->GetFieldID(env, endpointClass, "name", "Ljava/lang/String;"), 
                               javaName);
        CFRelease(name);        
    }
    
    [java release];
    
    return vector;
}
