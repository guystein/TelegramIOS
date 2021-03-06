/*
 * This is the source code of Telegram for iOS v. 1.1
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Peter Iakovlev, 2013.
 */

#import "TGSecretConversationHandshakeStatusPanel.h"

#import "TGViewController.h"

#import "TGImageUtils.h"
#import "TGFont.h"

@interface TGSecretConversationHandshakeStatusPanel ()
{
    CALayer *_stripeLayer;
    UILabel *_textLabel;
}

@end

@implementation TGSecretConversationHandshakeStatusPanel

- (CGFloat)baseHeight
{
    static CGFloat value = 0.0f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        value = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 45.0f : 56.0f;
    });
    
    return value;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, [self baseHeight])];
    if (self)
    {
        self.backgroundColor = UIColorRGBA(0xfafafa, 0.98f);
        
        _stripeLayer = [[CALayer alloc] init];
        _stripeLayer.backgroundColor = UIColorRGBA(0xb3aab2, 0.4f).CGColor;
        [self.layer addSublayer:_stripeLayer];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = TGSystemFontOfSize(14);
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _textLabel.text = text;
    [self setNeedsLayout];
}

- (void)adjustForOrientation:(UIInterfaceOrientation)orientation keyboardHeight:(float)keyboardHeight duration:(NSTimeInterval)duration animationCurve:(int)animationCurve
{
    [self _adjustForOrientation:orientation keyboardHeight:keyboardHeight duration:duration animationCurve:animationCurve];
}

- (void)_adjustForOrientation:(UIInterfaceOrientation)orientation keyboardHeight:(float)keyboardHeight duration:(NSTimeInterval)duration animationCurve:(int)animationCurve
{
    dispatch_block_t block = ^
    {
        id<TGModernConversationInputPanelDelegate> delegate = self.delegate;
        CGSize messageAreaSize = [delegate messageAreaSizeForInterfaceOrientation:orientation];
        
        self.frame = CGRectMake(0, messageAreaSize.height - keyboardHeight - [self baseHeight], messageAreaSize.width, [self baseHeight]);
        [self layoutSubviews];
    };
    
    if (duration > DBL_EPSILON)
        [UIView animateWithDuration:duration delay:0 options:animationCurve << 16 animations:block completion:nil];
    else
        block();
}

- (void)changeOrientationToOrientation:(UIInterfaceOrientation)orientation keyboardHeight:(float)keyboardHeight duration:(NSTimeInterval)duration
{
    [self _adjustForOrientation:orientation keyboardHeight:keyboardHeight duration:duration animationCurve:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _stripeLayer.frame = CGRectMake(0.0f, -TGRetinaPixel, self.frame.size.width, TGRetinaPixel);
    
    CGFloat maxTextSize = self.frame.size.width - 16.0f;
    CGSize textSize = [_textLabel sizeThatFits:CGSizeMake(maxTextSize, CGFLOAT_MAX)];
    textSize.width = MIN(textSize.width, maxTextSize);
    
    _textLabel.frame = CGRectMake(CGFloor((self.frame.size.width - textSize.width) / 2.0f), CGFloor((self.frame.size.height - textSize.height) / 2.0f), textSize.width, textSize.height);
}

@end
