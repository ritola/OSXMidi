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

@end