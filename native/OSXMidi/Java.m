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

- (jobject) newObject: (const char*) name : (const char*) signature {
    jclass c = (*env)->FindClass(env, name);
    return (*env)->NewObject(env, c, (*env)->GetMethodID(env, c, "<init>", signature));
}


@end