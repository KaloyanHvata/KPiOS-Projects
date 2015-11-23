//
//  DrawingViewController.m
//  CatAlbum
//
//  Created by Kaloyan Petrov on 10/7/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "DrawingViewController.h"
#import <CoreText/CoreText.h>

#define DURATION 4.0
#define FONT 70.0f

@interface DrawingViewController ()
@property (nonatomic, strong) CALayer *animationLayer;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, strong) CALayer *penLayer;
@end

@implementation DrawingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //setup background
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    background.image = [UIImage imageNamed:@"paper"];
    [self.view addSubview:background];
    
    //prepare animaion layer
    self.animationLayer = [CALayer layer];
    self.animationLayer.frame = CGRectMake(20.0f, 0, CGRectGetWidth(self.view.layer.bounds) - 40.0f, CGRectGetHeight(self.view.layer.bounds) - 84.0f);
    [self.view.layer addSublayer:self.animationLayer];
    
    [self setupTextLayer];
    [self startAnimation];
    
    //dismiss initial view controller with CurlUp animation
    double delayInSeconds = DURATION;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"Start"];
        UIWindow *window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
        [UIView transitionFromView:window.rootViewController.view
                            toView:nav.view
                          duration:0.65f
                           options:UIViewAnimationOptionTransitionCurlUp
                        completion:^(BOOL finished){
                            window.rootViewController = nav;
                        }];
    });
}

- (void) setupTextLayer
{
    if (self.pathLayer != nil) {
        [self.penLayer removeFromSuperlayer];
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
        self.penLayer = nil;
    }
    
    CGMutablePathRef letters = CGPathCreateMutable();
    
    CTFontRef font = CTFontCreateWithName(CFSTR("BradleyHandITCTT-Bold"), FONT, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Cat Album"
                                                                     attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor blackColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 3.0f;
    pathLayer.lineJoin = kCALineJoinRound;
    
    [self.animationLayer addSublayer:pathLayer];
    
    self.pathLayer = pathLayer;
    
    UIImage *penImage = [UIImage imageNamed:@"pen"];
    CALayer *penLayer = [CALayer layer];
    penLayer.contents = (id)penImage.CGImage;
    penLayer.anchorPoint = CGPointZero;
    penLayer.frame = CGRectMake(0.0f, 0.0f, penImage.size.width, penImage.size.height);
    [pathLayer addSublayer:penLayer];
    
    self.penLayer = penLayer;
}



- (void) startAnimation
{
    [self.pathLayer removeAllAnimations];
    [self.penLayer removeAllAnimations];
    
    self.penLayer.hidden = NO;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = DURATION;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    penAnimation.duration = DURATION;
    penAnimation.path = self.pathLayer.path;
    penAnimation.calculationMode = kCAAnimationPaced;
    penAnimation.delegate = self;
    [self.penLayer addAnimation:penAnimation forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.penLayer.hidden = YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
