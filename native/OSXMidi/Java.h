#import <JavaVM/jni.h>

jstring CFStringToJavaString(JNIEnv *, CFStringRef);

@interface Java : NSObject {
@protected
    JNIEnv* env;
}
-(Java*) initWithEnv: (JNIEnv*) env;
-(jclass) findClass: (const char*) name;
-(jobject) newObject: (const char*) name : (const char*) signature;
-(jsize) getArrayLength: (jbyteArray) array;
-(jbyte *) getByteArrayElements: (jbyteArray) array;
-(void) releaseByteArrayElements: (jbyteArray) array: (jbyte *) elements;
@end

@interface JavaObject : Java {
@public
    jobject object;
}
-(JavaObject*) initWithEnv: (JNIEnv) e object: (jobject) o;
-(jfieldID) findFieldId: (const char*) name : (const char*) signature;
-(void) callVoidMethod: (const char*) name : (const char*) signature, ...;

-(jobject) getObjectField: (const char*) name : (const char*) signature;
-(jlong) getLongField: (const char*) name;
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