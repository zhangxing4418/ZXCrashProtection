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
```objc
pod 'ZXCrashProtection'
```
## 如何使用
一共提供了5个方法：
* 用于判断防护系统是否启用
```objc
isWorking
```
* 设置崩溃信息反馈的代理
```objc
recordErrorDelegate:
```
* 选择启动单个或多个种类的防护
```objc
startWithProtectionType:
```
* 默认实时启动所有防护
```objc
start
```
* 实时关闭所有防护
```objc
stop
```
特别注意：其中recordErrorDelegate:方法一定要写在启动防护方法之前！！！

例如：
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //建议在该方法中优先处理
    [ZXCrashProtection recordErrorDelegate:self];
    [ZXCrashProtection start];
    //doSomething
    return YES;
}

- (void)recordErrorName:(NSString *)errorName reason:(NSString *)errorReason callStack:(NSArray *)callStack extraInfo:(NSDictionary *)extraInfo {
    NSLog(@"%@\n%@\n%@\n%@", errorName, errorReason, callStack, extraInfo);
}
```
你可以将反馈回来的崩溃信息上传到Bugly等平台上去
## END
我是佛系程序员👨‍💻‍
