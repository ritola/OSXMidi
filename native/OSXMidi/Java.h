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

- (jobject) newObject: (const char*) name : (const char*) signature;

- (void) setLongField: (jobject) object : (const char*) name : (long) value;
- (void) setObjectField: (jobject) object : (const char*) name : (const char*) signature : (jobject) value;
- (void) setStringField: (jobject) object : (const char*) name : (CFStringRef) value;

@end

@interface JavaVector : Java {
@private
    jobject vector;
}

-(JavaVector*) init: (JNIEnv*) env;
-(void) setVector: (jobject) vector;
-(jobject) getVector;
-(void) addElement: (jobject) o;

@end

@interface JavaMap : Java {
@private
    jobject map;
}

-(JavaMap*) init: (JNIEnv*) env map: (jobject) map;
-(void) setMap: (jobject) map;
-(jobject) getMap;
-(void) put: (jobject) key : (jobject) value;

@end