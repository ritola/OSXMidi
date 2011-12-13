#import "Midi.h"

@implementation MidiObject
-(MidiObject*) init: (JNIEnv*) e classname: (const char *) c object: (jobject) o {
    self = (MidiObject*) [super initWithEnv: e];
    object = o;
    [self setRef: (unsigned int) [self getLongField: "ref" ]];
    properties = [[JavaMap alloc] init: env map: [self getObjectField: "properties" : "Ljava/util/Map;"]];
    return self;
}
-(MidiObject*) init: (JNIEnv*) e classname: (const char *) c {
    self = (MidiObject*) [super initWithEnv: e];
    object = [self newObject: c : "()V"];
    properties = [[JavaMap alloc] init: env map: [self getObjectField: "properties" : "Ljava/util/Map;"]];
    return self;
}
-(void) setRef: (MIDIObjectRef) r {
    ref = r;
    [self setLongField: "ref" : ref];
    [self updateStringProperty: kMIDIPropertyName];
    [self updateStringProperty: kMIDIPropertyDisplayName];
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
-(MidiEndpoint*) init: (JNIEnv*) e classname: (const char *) c{
    self = (MidiEndpoint*) [super init: e classname: c];
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

@implementation MidiIn
-(MidiIn*) init: (JNIEnv *) e {
    self = (MidiIn*) [super init: e classname: "cx/oneten/osxmidi/jni/MidiIn"];
    return self;
}
@end

@implementation MidiOut
-(MidiOut*) init: (JNIEnv *) e {
    self = (MidiOut*) [super init: e classname: "cx/oneten/osxmidi/jni/MidiOut"];
    return self;
}
-(MidiOut*) init: (JNIEnv *) e object: (jobject) o {
    self = (MidiOut*) [super init: e classname: "cx/oneten/osxmidi/jni/MidiOut" object: o];
    return self;
}
-(MIDIPacketList) getPacketList: (jbyteArray) bytes {
    MIDIPacketList packetList;
    packetList.numPackets = 1;
    MIDIPacket* firstPacket = &packetList.packet[0];
    firstPacket->timeStamp = 0;
    firstPacket->length = [self getArrayLength: bytes] & 255;
    jbyte *b = [self getByteArrayElements: bytes];
    memcpy(firstPacket->data, b, firstPacket->length);
    [self releaseByteArrayElements: bytes : b];
    return packetList;
}
-(MIDIClientRef) getMidiClient {
    MIDIClientRef client;
    OSStatus err = MIDIClientCreate((CFStringRef)@"OSXMidi client", NULL, NULL, &client);
    if (err != noErr) printf("MIDI client create error: %i\n", err);
    return client;
}
-(MIDIPortRef) getOutputPort {
    MIDIPortRef port;
    OSStatus err = MIDIOutputPortCreate([self getMidiClient], (CFStringRef)@"OSXMidi output port", &port);
    if (err != noErr) printf("MIDI client create error: %i\n", err);
    return port;
}
-(void) sendMidi: (jbyteArray) bs {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
    MIDIClientRef client = [self getMidiClient];
    MIDIPortRef port = [self getOutputPort];
    OSStatus s;

    MIDIPacketList packetList=[self getPacketList: bs];

    OSStatus err = MIDISend(port, ref, &packetList);
    if (err != noErr) printf("MIDI sending error: %i\n", s);

    MIDIPortDispose(port);
    MIDIClientDispose(client);
    [pool release];
}
@end