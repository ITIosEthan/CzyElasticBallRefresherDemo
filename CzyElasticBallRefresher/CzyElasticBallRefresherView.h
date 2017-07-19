//
//  CzyElasticBallRefresherView.h
//  CzyElasticBallRefresher
//
//  Created by macOfEthan on 17/7/18.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CzyElasticBallRefresherView : UIView

/**高度*/
//@property (nonatomic, assign) CGFloat viewHeight;

/**偏移量*/
@property (nonatomic, assign) CGFloat contentOffSetY;


/**回弹*/
-(void)startBoundce;
- (void)stopBoundce;

/**旋转*/
- (void)startRotatiton;
- (void)stopRotation;


@end
