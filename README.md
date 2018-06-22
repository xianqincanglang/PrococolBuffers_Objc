* 1.将`*.proto`文件和对应生成的`*.pbobjc.h/*.pbobjc.m`导入项目中,并指定`*.pbobjc.m`为ARC编译`-fno-objc-arc`
* 2.将`objectivec`文件夹放入自己项目中
* 3.将ProtocolBuffers_iOS.xcodeproj添加到自己项目中
* 4.BuildSettings中:指定‘Header Search Paths’为'$(PROJECT)/objectivec'，否则会出现文件找不到问题;

