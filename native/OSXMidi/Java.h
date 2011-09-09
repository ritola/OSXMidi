#import <JavaVM/jni.h>

jstring CFStringToJavaString(JNIEnv *, CFStringRef);

@interface Java : NSObject {
@private
    JNIEnv* env;
}

-(Java*) initWithEnv: (JNIEnv*) env;

-(void) setEnv: (JNIEnv*) env;
- (jclass) findClass: (const char*) name;
- (jobject) newObject: (const char*) name : (const char*) signature;
- (void) callVoidMethod: (jobject) object : (const char*) name : (const char*) signature, ...;

- (void) setLongField: (jobject) object : (const char*) name : (long) value;
- (void) setObjectField: (jobject) object : (const char*) name : (const char*) signature : (jobject) value;
- (void) setStringField: (jobject) object : (const char*) name : (CFStringRef) value;

@end