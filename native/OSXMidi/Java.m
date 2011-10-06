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

-(JNIEnv *) getEnv {
    return env;
}

- (jclass) findClass: (const char*) name {
    return (*env)->FindClass(env, name);
}

- (jobject) newObject: (const char*) name : (const char*) signature {
    jclass c = [self findClass: name];
    return (*env)->NewObject(env, c, (*env)->GetMethodID(env, c, "<init>", signature));
}

@end

@implementation JavaObject
-(JavaObject*) initWithEnv: (JNIEnv) e object: (jobject) o {
    self = (JavaObject*) [super initWithEnv: (JNIEnv *) e];
    if ( self ) { [self setObject: o]; }
    return self;
}

-(void) setObject: (jobject) o {
    object = o;
}

-(jobject) getObject {
    return object;
}

- (jfieldID) findFieldId: (const char*) name : (const char*) signature {
    jclass c = (*env)->GetObjectClass(env, object);
    jfieldID id = NULL;
    while (id == NULL) {
        id = (*env)->GetFieldID(env, c, name, signature);
        jthrowable exc = (*env)->ExceptionOccurred(env);
        if (exc) {
            (*env)->ExceptionClear(env);
        }
        if (id != NULL) return id;
        c = (*env)->GetSuperclass(env, c);
        if (c == NULL) return NULL;
    }
    return id;
}

- (jmethodID) findMethodId: (const char*) name : (const char*) signature {
    jclass c = (*env)->GetObjectClass(env, object);
    jmethodID id = NULL;
    while (id == NULL) {
        id = (*env)->GetMethodID(env, c, name, signature);
        jthrowable exc = (*env)->ExceptionOccurred(env);
        if (exc) {
            (*env)->ExceptionClear(env);
        }
        if (id != NULL) return id;
        c = (*env)->GetSuperclass(env, c);
        if (c == NULL) return NULL;
    }
    return id;
}

- (void) callVoidMethod: (const char*) name : (const char*) signature, ... {
    jclass c = (*env)->GetObjectClass(env, object);
    
    va_list args;
    va_start(args, signature);
    (*env)->CallVoidMethodV(env, object, (*env)->GetMethodID(env, c, name, signature), args);
    va_end(args);
}

- (void) callObjectMethod: (const char*) name : (const char*) signature, ... {
    va_list args;
    va_start(args, signature);
    (*env)->CallObjectMethodV(env, object, [self findMethodId : name : signature], args);
    va_end(args);
}

- (jobject) getObjectField: (const char*) name : (const char*) signature {
    return (*env)->GetObjectField(env, object, [self findFieldId: name : signature]);
}

- (void) setLongField: (const char*) name : (long) value {
    jclass c = (*env)->GetObjectClass(env, object);
    (*env)->SetLongField(env, object, (*env)->GetFieldID(env, c, name, "J"), value);
}

- (void) setObjectField: (const char*) name : (const char*) signature : (jobject) value {
    jclass c = (*env)->GetObjectClass(env, object);
    (*env)->SetObjectField(env, object, (*env)->GetFieldID(env, c, name, signature), value);
}

- (void) setStringField: (const char*) name : (CFStringRef) value{
    jstring s = CFStringToJavaString(env, value);
    [self setObjectField: name : "Ljava/lang/String;" : s ];
}

@end

@implementation JavaVector
-(JavaVector*) init: (JNIEnv *) e {
    self = (JavaVector*) [super initWithEnv: e];
    [self setObject: [self newObject: "java/util/Vector" : "()V"]];
    return self;
}

-(void) addElement: (jobject) o {
    [self callVoidMethod: "addElement" : "(Ljava/lang/Object;)V", o];
}

@end

@implementation JavaMap
-(JavaMap*) init: (JNIEnv *) e map: (jobject) m {
    self = (JavaMap*) [super initWithEnv: e];
    [self setObject: m];
    return self;
}

-(void) put: (jobject) key : (jobject) value {
    [self callObjectMethod: "put" : "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;", key, value];
}

@end
