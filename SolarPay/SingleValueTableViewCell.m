//
//  SingleValueTableViewCell.m
//  SolarPay
//
//  Created by Matt Bowman on 1/25/14.
//  Copyright (c) 2014 AEC Planeteers. All rights reserved.
//

#import "SingleValueTableViewCell.h"
#import <ReactiveCocoa.h>

@interface SingleValueTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelLabel;

@end

@implementation SingleValueTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    RAC(self, labelLabel.text) = RACObserve(self, labelText);
    RAC(self, valueLabel.text) = RACObserve(self, valueText);
}

- (void)prepareForReuse
{
    self.valueText = @"";
    self.labelText = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
