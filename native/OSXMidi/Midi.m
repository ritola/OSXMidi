#import "Midi.h"

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


@implementation MidiObject
-(MidiObject*) init: (JNIEnv*) e classname: (const char *) c {
    self = (MidiObject*) [super initWithEnv: e];
    object = [self newObject: c : "()V"];
    properties = [[JavaMap alloc] init: env map: [self getObjectField: "properties" : "Ljava/util/Map;"]];
    return self;
}
-(void) setRef: (MIDIObjectRef) r {
    ref = r;
    [self setLongField: "ref" : ref];
    CFStringRef value = CreateEndpointName(ref, false);
    [self updateStringProperty: kMIDIPropertyName];
    CFRelease(value);
}
-(void) updateStringProperty: (CFStringRef) propertyID {
    CFStringRef str = NULL;
    MIDIObjectGetStringProperty(ref, propertyID, &str);
    if (str != NULL) {
        [properties put: CFStringToJavaString(env, propertyID) : CFStringToJavaString(env, str)];
        CFRelease(str);
    }
}
-(void) dealloc {
    [properties dealloc];
    [super dealloc];
}
@end

@implementation MidiDevice
-(MidiDevice*) init: (JNIEnv *) e {
    self = (MidiDevice*) [super init: e classname: "cx/oneten/osxmidi/jni/MidiDevice"];
    return self;
}
@end

@implementation MidiEntity
-(MidiEntity*) init: (JNIEnv *) e {
    self = (MidiEntity*) [super init: e classname: "cx/oneten/osxmidi/jni/MidiEntity"];
    device = nil;
    return self;
}
-(void) setRef: (MIDIObjectRef) r {
    [super setRef: r];
    [device dealloc];
    MIDIDeviceRef d = 0;
    MIDIEntityGetDevice(ref, &d);
    if (d != 0) {
        device = [[MidiEntity alloc] init: env];
        [device setRef: d];
        [self callVoidMethod: "setDevice": "(Lcx/oneten/osxmidi/jni/MidiDevice;)V", device->object];
    }
}
-(void) dealloc {
    [device dealloc];
    [super dealloc];
}
@end

@implementation MidiEndpoint
-(MidiEndpoint*) init: (JNIEnv *) e {
    self = (MidiEndpoint*) [super init: e classname: "cx/oneten/osxmidi/jni/MidiEndpoint"];
    entity = nil;
    return self;
}
-(void) setRef: (MIDIObjectRef) r {
    [super setRef: r];
    [entity dealloc];
    MIDIEntityRef e = 0;
    MIDIEndpointGetEntity(ref, &e);
    if (e != 0) {
        entity = [[MidiEntity alloc] init: env];
        [entity setRef: e];
        [self callVoidMethod: "setEntity": "(Lcx/oneten/osxmidi/jni/MidiEntity;)V", entity->object];
    }
}
-(void) dealloc {
    [entity dealloc];
    [super dealloc];
}
@end
