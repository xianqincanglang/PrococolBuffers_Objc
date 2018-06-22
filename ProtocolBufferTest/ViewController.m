//
//  ViewController.m
//  ProtocolBufferTest
//
//  Created by chentianyu on 2018/6/8.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import "ViewController.h"
#import "Person.pbobjc.h"

@interface ViewController ()

@property (nonatomic, weak) UILabel *infoLbl; //展示信息
@property (nonatomic, strong) NSData *myData; //数据

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self intSubview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)intSubview
{
    //1、序列化按钮
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, 120, 30)];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"序列化" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(serialize:) forControlEvents:UIControlEventTouchUpInside];
    btn1.layer.borderColor = [UIColor orangeColor].CGColor;
    btn1.layer.borderWidth = 1;
    [self.view addSubview:btn1];
    
    //2、反序列化按钮
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(180, 80, 120, 30)];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"反序列化" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(deserialize:) forControlEvents:UIControlEventTouchUpInside];
    btn2.layer.borderColor = [UIColor orangeColor].CGColor;
    btn2.layer.borderWidth = 1;
    [self.view addSubview:btn2];
    
    //3、用来展示信息
    UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, [UIScreen mainScreen].bounds.size.width - 20, 300)];
    infoLbl.textColor = [UIColor blackColor];
    infoLbl.numberOfLines = 0;
    [self.view addSubview:infoLbl];
    self.infoLbl = infoLbl;
}

#pragma mark - 序列化
- (void)serialize:(UIButton *)sender{
    // 创建对象
    Person *per = [[Person alloc] init];
    per.name = @"小明";
    per.age = 18;
    per.deviceType = Person_DeviceType_Ios;
    
    //对象数组属性：Person_Result
    Person_Result *result1 = [[Person_Result alloc] init];
    result1.title = @"百度";
    result1.URL = @"http://baidu.com";
    [per.resultsArray addObject:result1];
    
    
    Person_Result *result2 = [[Person_Result alloc] init];
    result2.title = @"博客园";
    result2.URL = @"http://cnblogs.com";
    [per.resultsArray addObject:result2];
    
    //对象数组属性：Ani
    Animal *an1 = [[Animal alloc] init];
    an1.weight = 80;
    an1.price = 1000;
    an1.namme = @"小狗";
    
    [per.animalsArray addObject:an1];
    
    //对象序列化：存储或传递
    NSData *data = [per delimitedData];
    self.myData = data;
    
    self.infoLbl.text = @"数据序列化成功！";
}

#pragma mark - 反序列化
- (void)deserialize:(UIButton *)sender
{
    
    GPBCodedInputStream *inputStream = [GPBCodedInputStream streamWithData:self.myData];
    NSError *error;
    Person *per = [Person parseDelimitedFromCodedInputStream:inputStream extensionRegistry:nil error:&error];
    if (error) {
        self.infoLbl.text  = @"解析数据失败";
        return;
    }
    //展示数据
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:@"二进制数据反序列化为对象\n"];
    [str appendFormat:@"name: %@， age: %d \n",per.name,per.age];
    for (Person_Result *item in per.resultsArray) {
        [str appendFormat:@"result.title:%@, result.url:%@\n",item.title,item.URL];
    }
    for (Animal *item in per.animalsArray) {
        [str appendFormat:@"animal.name:%@, animal.price:%.2f, animal.weight:%.2f\n",item.namme,item.price,item.weight];
    }
    self.infoLbl.text = str;
}
@end
