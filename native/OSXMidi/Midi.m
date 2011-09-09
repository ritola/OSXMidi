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
