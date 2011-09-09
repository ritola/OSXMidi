#import "OSXMidi.h"
#import "Midi.h"

jstring CFStringToJavaString(JNIEnv *env, CFStringRef str)
{
    CFRange range;
    range.location = 0;
    range.length = CFStringGetLength(str);
    UniChar charBuf[range.length];
    CFStringGetCharacters(str, range, charBuf);
    return (*env)->NewString(env, (jchar *)charBuf, (jsize)range.length);
}

JNIEXPORT jobject JNICALL Java_cx_oneten_osxmidi_OSXMidi_getEndpoints
(JNIEnv *env, jclass clazz)
{
    jclass vectorClass = (*env)->FindClass(env, "java/util/Vector");
    jclass endpointClass = (*env)->FindClass(env, "cx/oneten/osxmidi/jni/MidiEndpoint");
    jobject vector = (*env)->NewObject(env, vectorClass, (*env)->GetMethodID(env, vectorClass, "<init>", "()V"));
    jmethodID vectorAddElementId = (*env)->GetMethodID(env, vectorClass, "addElement", "(Ljava/lang/Object;)V");
    jmethodID endpointCreateId = (*env)->GetMethodID(env, endpointClass, "<init>", "()V");
                                              
    ItemCount count = MIDIGetNumberOfSources();
    for (ItemCount i = 0; i < count; i++) {
        jobject midiEndpoint = (*env)->NewObject(env, endpointClass, endpointCreateId);
        (*env)->CallVoidMethod(env, vector, vectorAddElementId, midiEndpoint);

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
        jobject midiEndpoint = (*env)->NewObject(env, endpointClass, endpointCreateId);
        (*env)->CallVoidMethod(env, vector, vectorAddElementId, midiEndpoint);
        
        MIDIEndpointRef destination = MIDIGetDestination(i);
        (*env)->SetLongField(env, midiEndpoint, (*env)->GetFieldID(env, endpointClass, "ref", "J"), destination);
        
        CFStringRef name = CreateEndpointName(destination, false);
        jstring javaName = CFStringToJavaString(env, name);
        (*env)->SetObjectField(env, midiEndpoint, (*env)->GetFieldID(env, endpointClass, "name", "Ljava/lang/String;"), 
                               javaName);
        CFRelease(name);        
    }
    
    return vector;
}
