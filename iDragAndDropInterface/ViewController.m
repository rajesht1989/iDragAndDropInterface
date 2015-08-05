//
//  ViewController.m
//  iDragAndDropInterface
//
//  Created by Rajesh on 7/31/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import "ViewController.h"

#define COPY_TAG 999

@interface ViewController ()
{
    NSMutableArray *arrItems;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [_tableView setHidden:YES];
    arrItems = [NSMutableArray array];
    [_scrollview.layer setBorderWidth:.5];
    [_scrollview.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [_scrollview setClipsToBounds:NO];
    [_scrollview setShowsHorizontalScrollIndicator:NO];
    [self.view bringSubviewToFront:_scrollview];
    
    
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 40)];
    [labelOne setTag:1];
    [labelOne setText:@"One"];
    [self configureLabelAndAdd:labelOne];


    UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelOne.frame) + 30, 5, 100, 40)];
    [labelTwo setTag:2];
    [labelTwo setText:@"Two"];
    [self configureLabelAndAdd:labelTwo];

    
    UILabel *labelThree = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelTwo.frame) + 30, 5, 100, 40)];
    [labelThree setTag:3];
    [labelThree setText:@"Three"];
    [self configureLabelAndAdd:labelThree];

    
    UILabel *labelFour = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelThree.frame) + 30, 5, 100, 40)];
    [labelFour setTag:4];
    [labelFour setText:@"Four"];
    [self configureLabelAndAdd:labelFour];
    
    [_scrollview setContentSize:CGSizeMake(CGRectGetMaxX(labelFour.frame) + 10, 40)];
}

- (void)configureLabelAndAdd:(UILabel *)label
{
    [label setTextAlignment:NSTextAlignmentCenter];
    [label.layer setCornerRadius:2.];
    [label.layer setBorderWidth:.5];
    [label.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [label setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *itemPanGesture  = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(productDrag:)];
    [label addGestureRecognizer:itemPanGesture];
    [_scrollview addSubview:label];
}


- (void)productDrag:(UIPanGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        UILabel *lblOriginal = (UILabel *)gesture.view;
        
        
        UILabel *lblDuplicate = [[UILabel alloc] initWithFrame:lblOriginal.frame];
        [self configureLabelAndAdd:lblDuplicate];
        [lblDuplicate setTag:lblOriginal.tag];
        [lblDuplicate setText:lblOriginal.text];
        [_scrollview addSubview:lblDuplicate];
        [lblOriginal setTag:COPY_TAG];
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        UILabel *lblDupe = (UILabel *)gesture.view;
        if (lblDupe.tag == COPY_TAG)
        {
            CGPoint translation = [gesture translationInView:lblDupe];
            lblDupe.center = CGPointMake(lblDupe.center.x + translation.x,lblDupe.center.y + translation.y);
            [gesture setTranslation:CGPointZero inView:lblDupe];
        }
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        UILabel *lblDupe = (UILabel *)gesture.view;
        [UIView animateWithDuration:.4 animations:^{
            [lblDupe setAlpha:.0];
        } completion:^(BOOL finished) {
            if (lblDupe.frame.origin.y > _scrollview.frame.size.height)
            {
                [arrItems addObject:lblDupe.text];
                [_tableView reloadData];
            }
            [lblDupe removeFromSuperview];
        }];
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    [cell.textLabel setText:arrItems[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
