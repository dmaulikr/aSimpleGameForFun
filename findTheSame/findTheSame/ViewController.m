//
//  ViewController.m
//  findTheSame
//
//  Created by lanou on 15/12/26.
//  Copyright © 2015年 zhiwei. All rights reserved.
//

#import "ViewController.h"
#import "ButtonForCrash.h"

@interface ViewController ()
@property (nonatomic, assign)NSInteger rows;
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, assign)NSInteger power;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger judge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.power = 0;
    self.count = 2;
    self.rows = 1;
    [self start];
}

- (void)buttonAction:(ButtonForCrash *)button {
    static NSInteger compareMarkStore = -1;
    static NSInteger tagStore = -1;
    if (button.backgroundColor != [UIColor whiteColor]) {
        if (self.judge % 2 == 0) {
            compareMarkStore = button.compareMark;
            tagStore = button.tag;
        }
        if (self.judge % 2 == 1) {
            if (tagStore != button.tag) {
                if (button.compareMark == compareMarkStore) {
                    button.backgroundColor = [UIColor whiteColor];
                    [self.view viewWithTag:tagStore].backgroundColor = [UIColor whiteColor];
                }
                else {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"色块不相同" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
                    [self presentViewController:alertC animated:YES completion:nil];
                    [alertC addAction:action];
                }
            }
            else {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"不能点击同一块色块" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
                [self presentViewController:alertC animated:YES completion:nil];
                [alertC addAction:action];
            }
            compareMarkStore = -1;
            tagStore = -1;
        }
        self.judge++;
        [self ifwin];
    }
}

- (void)ifwin {
    NSInteger mark = 0;
    for (ButtonForCrash *button in self.array) {
        if (button.backgroundColor != [UIColor whiteColor]) {
            mark += 1;
        }
    }
    if (mark == 1 || mark == 0) {
        self.power += 1;
        if (self.power < 8) {
            self.count -= self.power / 2;
        }
        if (self.power >= 9) {
            self.count += self.power * (self.power - 8) + 3;
        }
        [self.timer invalidate];
        self.view = [[UIView alloc]init];
        [self start];
    }
    
}

- (void)start {
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.count += (self.power + 1) * self.power;
    self.rows += 1;
    CGFloat oneWidth = width / (self.rows * 15 + 1);
    
    self.array = [[NSMutableArray alloc]init];
    self.judge = 0;
    
    for (int i = 0; i < self.rows * self.rows; i++) {
        ButtonForCrash *button = [ButtonForCrash buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(oneWidth + (i % self.rows) * 15 * oneWidth, width / 4 + (i / self.rows) * 15 * oneWidth, 14 * oneWidth, 14 * oneWidth);
        button.backgroundColor = [UIColor colorWithRed:[self random] green:[self random] blue:[self random] alpha:[self random]];
        button.tag = i + 1;
        [self.array addObject:button];
        button.compareMark = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    
    
    NSMutableArray *arrayStore = [[NSMutableArray alloc]init];
    for (ButtonForCrash *button in self.array) {
        [arrayStore addObject:button];
    }
    for (int i = 0; i < self.rows * self.rows / 2; i++) {
        NSNumber *num1 = [NSNumber numberWithInteger:arc4random() % (self.rows * self.rows - 2 * i)];
        NSNumber *num2 = [NSNumber numberWithInteger:arc4random() % (self.rows * self.rows - 2 * i)];
        while ([num1 integerValue] == [num2 integerValue]) {
            num2 = [NSNumber numberWithInteger:arc4random() % (self.rows * self.rows - 2 * i)];
        }
        ButtonForCrash *button1 = arrayStore[[num1 integerValue]];
        ButtonForCrash *button2 = arrayStore[[num2 integerValue]];
        ButtonForCrash *buttonNeed1 = [self.view viewWithTag:button1.tag];
        ButtonForCrash *buttonNeed2 = [self.view viewWithTag:button2.tag];
        buttonNeed1.backgroundColor = buttonNeed2.backgroundColor;
        buttonNeed1.compareMark = buttonNeed2.compareMark;
        if ([num1 integerValue] < [num2 integerValue]) {
            [arrayStore removeObject:button2];
            [arrayStore removeObject:button1];
        }
        else{
            [arrayStore removeObject:button1];
            [arrayStore removeObject:button2];
        }
    }
    
    UILabel *Timelabel = [[UILabel alloc]initWithFrame:CGRectMake(width / 4, 600, 100, 40)];
    Timelabel.center = CGPointMake(width / 2, 600);
    Timelabel.backgroundColor = [UIColor lightGrayColor];
    Timelabel.layer.cornerRadius = 8;
    Timelabel.clipsToBounds = YES;
    Timelabel.tag = 2000;
    Timelabel.textAlignment = NSTextAlignmentCenter;
    Timelabel.font = [UIFont fontWithName:@"thonburi-Bold" size:25];
    Timelabel.textColor = [UIColor whiteColor];
    Timelabel.text = [NSString stringWithFormat:@"%li", self.count];
    [self.view addSubview:Timelabel];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(timeLimit) userInfo:nil repeats:YES];
    
    
    UILabel *Timelabel1 = [[UILabel alloc]initWithFrame:CGRectMake(width / 4, 50, 50, 40)];
    Timelabel1.center = CGPointMake(width / 2, 660);
    Timelabel1.backgroundColor = [UIColor whiteColor];
    Timelabel1.layer.cornerRadius = 8;
    Timelabel1.clipsToBounds = YES;
    Timelabel1.tag = 2001;
    Timelabel1.textAlignment = NSTextAlignmentCenter;
    Timelabel1.font = [UIFont fontWithName:@"thonburi-Bold" size:25];
    Timelabel1.textColor = [UIColor grayColor];
    [self.view addSubview:Timelabel1];
    Timelabel1.text = [NSString stringWithFormat:@"%li", self.power + 1];
    
    
}

- (float)random {
    double random = 0;
    while (random < 0.4 || random > 0.9) {
        random = arc4random() % 256 / 255.0;
    }
    return random;
}

- (void)timeLimit {
    if (self.count >= 0) {
        self.count -= 1;
    }
    if (self.count == 0) {
        [self.timer invalidate];
        NSString *winStr = [NSString stringWithFormat:@"才过了 %li 关, 就这点儿水平?", self.power];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"时间到了" message:winStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"再来一盘" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.count = 2;
            self.view = [[UIView alloc]init];
            self.power = 0;
            self.rows = 1;
            self.judge = 0;
            [self start];
        }];
        [self presentViewController:alertC animated:YES completion:nil];
        [alertC addAction:action2];
        
    }
    if ((self.count < self.power * 4) || (self.power >= 9 && self.count < (self.power * (self.power - self.power / 2) + self.power))){
        for (ButtonForCrash *button in self.array) {
            [button setTitle:[NSString stringWithFormat:@"%li", button.compareMark] forState:UIControlStateNormal];
            [button setTintColor:[UIColor whiteColor]];
            if (self.rows > 12) {
                button.titleLabel.font = [UIFont systemFontOfSize:10];
            }
            else if(self.rows <= 12 && self.rows >8) {
                [button.titleLabel adjustsFontSizeToFitWidth];
            }
            else if(self.rows <= 8 && self.rows >= 6) {
                button.titleLabel.font = [UIFont systemFontOfSize:23];
            }
            else {
                button.titleLabel.font = [UIFont systemFontOfSize:30];
            }
        }
    }
    UILabel *label = [self.view viewWithTag:2000];
    label.text = [NSString stringWithFormat:@"%li", self.count];
    NSLog(@"%li", self.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}

@end
