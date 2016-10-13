//
//  ViewController.m
//  Demo_UiTexiField
//
//  Created by dqh on 16/10/12.
//  Copyright © 2016年 duqianhang. All rights reserved.
//

#import "ViewController.h"

#define MAX_STRING_LENGTH 10

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)creatView {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    textField.backgroundColor = [UIColor grayColor];
    textField.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
    [textField addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.delegate = self;
    [self.view addSubview:textField];
}

- (void)textFiledEditChanged:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        // 禁止系统表情的输入
        NSString *text = [self disable_emoji:textField.text];
        if (![text isEqualToString:textField.text]) {
            textField.text = text;
        }
    }
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (textField.text.length > MAX_STRING_LENGTH) {
            textField.text = [textField.text substringToIndex:MAX_STRING_LENGTH];
        }
    }
}

- (NSString *)disable_emoji:(NSString *)text{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}


#pragma mark ----UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //当文本输入模式为"emoji"时禁止输入
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
