#import <JavaVM/jni.h>

jstring CFStringToJavaString(JNIEnv *, CFStringRef);

@interface Java : NSObject {
@protected
    JNIEnv* env;
}

-(Java*) initWithEnv: (JNIEnv*) env;

-(void) setEnv: (JNIEnv*) env;
-(jclass) findClass: (const char*) name;
-(jobject) newObject: (const char*) name : (const char*) signature;
@end

@interface JavaObject : Java {
@private
    jobject object;
}
-(JavaObject*) initWithEnv: (JNIEnv) e object: (jobject) o;
-(void) setObject: (jobject) o;
-(jobject) getObject;

-(jfieldID) findFieldId: (const char*) name : (const char*) signature;
-(void) callVoidMethod: (const char*) name : (const char*) signature, ...;

-(jobject) getObjectField: (const char*) name : (const char*) signature;
-(void) setLongField: (const char*) name : (long) value;
-(void) setObjectField: (const char*) name : (const char*) signature : (jobject) value;
-(void) setStringField: (const char*) name : (CFStringRef) value;
@end

@interface JavaVector : JavaObject {}
-(JavaVector*) init: (JNIEnv*) env;
-(void) addElement: (jobject) o;
@end

@interface JavaMap : JavaObject {}
-(JavaMap*) init: (JNIEnv*) env map: (jobject) map;
-(void) put: (jobject) key : (jobject) value;
@end