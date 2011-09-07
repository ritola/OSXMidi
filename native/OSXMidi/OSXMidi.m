#import "OSXMidi.h"

//////////////////////////////////////
// Obtain the name of an endpoint without regard for whether it has connections.
// The result should be released by the caller.
CFStringRef CreateEndpointName(MIDIEndpointRef endpoint, bool isExternal)
{
    CFMutableStringRef result = CFStringCreateMutable(NULL, 0);
    CFStringRef str;
    
    // begin with the endpoint's name
    str = NULL;
    MIDIObjectGetStringProperty(endpoint, kMIDIPropertyName, &str);
    if (str != NULL) {
        CFStringAppend(result, str);
        CFRelease(str);
    }
    
    MIDIEntityRef entity = NULL;
    MIDIEndpointGetEntity(endpoint, &entity);
    if (entity == NULL)
        // probably virtual
        return result;
    
    if (CFStringGetLength(result) == 0) {
        // endpoint name has zero length -- try the entity
        str = NULL;
        MIDIObjectGetStringProperty(entity, kMIDIPropertyName, &str);
        if (str != NULL) {
            CFStringAppend(result, str);
            CFRelease(str);
        }
    }
    // now consider the device's name
    MIDIDeviceRef device = NULL;
    MIDIEntityGetDevice(entity, &device);
    if (device == NULL)
        return result;
    
    str = NULL;
    MIDIObjectGetStringProperty(device, kMIDIPropertyName, &str);
    if (str != NULL) {
        // if an external device has only one entity, throw away 
        // the endpoint name and just use the device name
        if (isExternal && MIDIDeviceGetNumberOfEntities(device) < 2) {
            CFRelease(result);
            return str;
        } else {
            // does the entity name already start with the device name? 
            // (some drivers do this though they shouldn't)
            // if so, do not prepend
            if (CFStringCompareWithOptions(str /* device name */, 
                                           result /* endpoint name */, 
                                           CFRangeMake(0, CFStringGetLength(str)), 0) != kCFCompareEqualTo) {
                // prepend the device name to the entity name
                if (CFStringGetLength(result) > 0)
                    CFStringInsert(result, 0, CFSTR(" "));
                CFStringInsert(result, 0, str);
            }
            CFRelease(str);
        }
    }
    return result;
}

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
