//
//  ChartCell.m
//  SolarPay
//
//  Created by Matt Bowman on 1/25/14.
//  Copyright (c) 2014 AEC Planeteers. All rights reserved.
//

#import "ChartCell.h"

#import <PNChart/PNChart.h>
#import <PNChart/PNLineChartData.h>
#import <PNChart/PNLineChartDataItem.h>

@interface ChartCell()

@property (nonatomic, weak) PNLineChart *lineChart;
@property (nonatomic, weak) UIScrollView *chartContainer;

@end


@implementation ChartCell

-(void)awakeFromNib
{
    UIScrollView *graphContainer = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    
    [self.contentView addSubview:graphContainer];
    self.chartContainer = graphContainer;
}

- (void)setResults:(NSDictionary *)results
{
    _results = results;
    
    [self.lineChart removeFromSuperview];
    
    CGRect size = CGRectMake(0, 0, self.contentView.bounds.size.width * 3, self.contentView.bounds.size.height);
    
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:size];
    lineChart.backgroundColor = [UIColor clearColor];
    
    NSMutableArray* years = [[NSMutableArray alloc] init];
    NSMutableArray* savings = [[NSMutableArray alloc] init];
    
    for (NSDictionary* annual_saving in _results[@"annual_savings_by_year"])
    {
        [years addObject:annual_saving.allKeys.firstObject];
        [savings addObject:annual_saving.allValues.firstObject];
    }
    
    [lineChart setXLabels:years];
    
    // Line Chart Nr.1
    NSArray * data01Array = savings;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data01Array objectAtIndex:index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart Nr.2
//    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
//    PNLineChartData *data02 = [PNLineChartData new];
//    data02.color = PNTwitterColor;
//    data02.itemCount = lineChart.xLabels.count;
//    data02.getData = ^(NSUInteger index) {
//        CGFloat yValue = [[data02Array objectAtIndex:index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
    
    lineChart.chartData = @[data01];
    [lineChart strokeChart];
    
    self.lineChart = lineChart;
    [self.chartContainer addSubview:lineChart];
    self.chartContainer.contentSize = size.size;
}

@end
