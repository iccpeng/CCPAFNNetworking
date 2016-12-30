//
//  CCPDataTableViewCell.m
//  CCPAFNNetworking
//
//  Created by C CP on 16/9/11.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "CCPDataTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CCPDataTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end

@implementation CCPDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(CCPModel *)model {
    
    _model = model;
    
    self.infoLabel.text = model.title;
    
    NSURL *url = [NSURL URLWithString:model.kpic];
    
    [self.showImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_50"]];
    
}



@end
