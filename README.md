# ZXCrashProtection
在App运行发生崩溃时及时阻止和进行修复，项目在开发过程中借鉴了网易的大白健康系统和XXShield的crash解决方案。项目增强了App的健壮性，并可以在发生崩溃时返回崩溃信息，以利于开发者去进行修复，现在项目支持以下种类的奔溃，后期还将不断进行完善和新增新的崩溃防护：
* Unrecognized selector crash
* KVO crash
* NSNotification crash
* NSTimer crash
* Container crash
* NSString crash
* NSNull crash
## 如何安装
pod 'ZXCrashProtection'
## 如何使用
一共提供了5个方法：
* isWorking
用于判断防护系统是否启用
* recordErrorDelegate:
设置崩溃信息反馈的代理
* starWithProtectionType:
启动单个种类的防护
* star
默认实时启动所有防护
* stop
实时关闭所有防护
特别注意：其中recordErrorDelegate:方法一定要写在启动防护方法之前！！！

例如：
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ZXCrashProtection recordErrorDelegate:self];
    [ZXCrashProtection start];
    return YES;
}

- (void)recordErrorName:(NSString *)errorName reason:(NSString *)errorReason callStack:(NSArray *)callStack extraInfo:(NSDictionary *)extraInfo {
    NSLog(@"%@\n%@\n%@\n%@", errorName, errorReason, callStack, extraInfo);
}
```
你可以将反馈回来的崩溃信息上传到Bugly等平台上去
