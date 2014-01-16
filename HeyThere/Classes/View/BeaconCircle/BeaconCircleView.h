#import <UIKit/UIKit.h>

typedef enum
{
    BeaconDirectionUp = 0,
    BeaconDirectionDown = 1,
} BeaconDirection;

@interface BeaconCircleView : UIView

- (void)startAnimationWithDirection:(BeaconDirection)direction;
- (void)stopAnimation;
@end
