#import "Java.h"

jstring CFStringToJavaString(JNIEnv *env, CFStringRef str)
{
    CFRange range;
    range.location = 0;
    range.length = CFStringGetLength(str);
    UniChar charBuf[range.length];
    CFStringGetCharacters(str, range, charBuf);
    return (*env)->NewString(env, (jchar *)charBuf, (jsize)range.length);
}

@implementation Java
-(Java*) initWithEnv: (JNIEnv *) e {
    self = [super init];
    
    if ( self ) {
        [self setEnv: e];
    }
    return self;
}

-(void) setEnv: (JNIEnv *) e {
    env = e;
}

- (jclass) findClass: (const char*) name {
    return (*env)->FindClass(env, name);
}

- (jobject) newObject: (const char*) name : (const char*) signature {
    jclass c = [self findClass: name];
    return (*env)->NewObject(env, c, (*env)->GetMethodID(env, c, "<init>", signature));
}

- (void) callVoidMethod: (jobject) object : (const char*) name : (const char*) signature, ... {
    jclass c = (*env)->GetObjectClass(env, object);

    va_list args;
    va_start(args, signature);
    (*env)->CallVoidMethodV(env, object, (*env)->GetMethodID(env, c, name, signature), args);
    va_end(args);
}

- (void) setLongField: (jobject) object : (const char*) name : (long) value {
    jclass c = (*env)->GetObjectClass(env, object);
    (*env)->SetLongField(env, object, (*env)->GetFieldID(env, c, name, "J"), value);
}

- (void) setObjectField: (jobject) object : (const char*) name : (const char*) signature : (jobject) value {
    jclass c = (*env)->GetObjectClass(env, object);
    (*env)->SetObjectField(env, object, (*env)->GetFieldID(env, c, name, signature), value);
}

- (void) setStringField: (jobject) object : (const char*) name : (CFStringRef) value{
    jstring s = CFStringToJavaString(env, value);
    [self setObjectField: object : name : "Ljava/lang/String;" : s ];
}

@end

@implementation JavaVector
-(JavaVector*) init: (JNIEnv *) e {
    self = (JavaVector*) [super initWithEnv: (JNIEnv *) e];
    [self setVector: [self newObject: "java/util/Vector" : "()V"]];
    return self;
}

-(void) setVector: (jobject) v {
    vector = v;
}

-(jobject) getVector {
    return vector;
}

-(void) addElement: (jobject) o {
    [self callVoidMethod: vector :"addElement" : "(Ljava/lang/Object;)V", o];
}

@end
