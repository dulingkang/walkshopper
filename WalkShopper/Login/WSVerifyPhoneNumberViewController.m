//
//  WSVerifyPhoneNumberViewController.m
//  WalkShopper
//
//  Created by 丁 一 on 15/9/24.
//  Copyright © 2015年 Ding Yi. All rights reserved.
//

#import "WSVerifyPhoneNumberViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "MSWeakTimer.h"

@interface WSVerifyPhoneNumberViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@property (assign, nonatomic) NSInteger countDownSeconds;
@property (strong, nonatomic) MSWeakTimer *timer;

@end

@implementation WSVerifyPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.getVerificationCodeBtn.addTarget(self, action: "getVerificationCode", forControlEvents: UIControlEvents.TouchUpInside)
//    self.nextStepBtn.addTarget(self, action: "nextStep", forControlEvents: UIControlEvents.TouchUpInside)
//    self.countDownLabel.hidden = true
    [self.getVerificationCodeBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    self.countDownLabel.hidden = YES;
}

- (void)getVerificationCode
{
    if ([self isPhoneNumValid] == NO) {
        return;
    }
    self.countDownSeconds = 60;
    self.countDownLabel.text = [NSString stringWithFormat:@"剩余%ld秒", (long)self.countDownSeconds];
    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountDownLabel) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    self.countDownLabel.hidden = NO;
    self.getVerificationCodeBtn.hidden = YES;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumberTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (error) {
            
        } else {
            NSLog(@"获取验证码成功");
        }
    }];
}

- (void)updateCountDownLabel
{
    self.countDownSeconds--;
    if (self.countDownSeconds == -1) {
        [self.timer invalidate];
        self.getVerificationCodeBtn.hidden = NO;
        self.countDownLabel.hidden = YES;
    }
    self.countDownLabel.text = [NSString stringWithFormat:@"剩余%ld秒", (long)self.countDownSeconds];
}

- (void)nextStep
{
    if ([self isVerificationCodeValid] == NO) {
        return;
    }
    [SMSSDK commitVerificationCode:self.verificationCodeTextField.text phoneNumber:self.phoneNumberTextField.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            NSLog(@"注册成功");
        } else {
            
        }
    }];
}



- (BOOL)isPhoneNumValid
{
    if (self.phoneNumberTextField.text.length == 0) {
        return NO;
    }
    NSString *rule = @"^1(3|5|7|8|4)\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    BOOL isMatch = [pred evaluateWithObject:self.phoneNumberTextField.text];
    if (isMatch == NO) {
        
    }
    return isMatch;
}

- (BOOL)isVerificationCodeValid
{
    if (self.verificationCodeTextField.text.length == 0) {
        return NO;
    }
    NSString *rule = @"^\\d{4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    BOOL isMatch = [pred evaluateWithObject:self.verificationCodeTextField.text];
    if (isMatch == NO) {
        
    }
    return isMatch;
}

@end
