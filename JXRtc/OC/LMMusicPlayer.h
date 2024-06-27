//
//  LMMusicPlayer.h
//  LanMaoVoice
//
//  Created by qicaiyuan on 2024/2/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMMusicPlayer : NSObject

+ (LMMusicPlayer *)shared;
+ (void)play;
+ (void)stop;
@end

NS_ASSUME_NONNULL_END
