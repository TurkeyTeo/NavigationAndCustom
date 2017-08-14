//
//  TableViewCell.m
//  NavigationAndCustom
//
//  Created by Teo on 2017/8/9.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()

@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation TableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpview];
    }
    return self;
}

- (void)setUpview{
    [self addSubview:self.imageV];
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 7, 30, 30)];
        if (arc4random() % 3 == 1) {
            _imageV.image = [UIImage imageNamed:@"account_highlight"];
        }else{
            _imageV.image = [UIImage imageNamed:@"mycity_highlight"];
        }
        _imageV.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    return _imageV;
}

- (void)setRadios:(CGFloat)radios{
    _radios = radios;
    self.imageV.layer.cornerRadius = radios;
    self.imageV.layer.masksToBounds = YES;
}

@end
