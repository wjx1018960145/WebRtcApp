//
//  LMMusicPlayer.m
//  LanMaoVoice
//
//  Created by qicaiyuan on 2024/2/7.
//

#import "LMMusicPlayer.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "FFT.h"
#import "SpectrumScrollView.h"
static LMMusicPlayer *acIndicator = nil;
@interface LMMusicPlayer()<PLPlayerDelegate>
@property(nonatomic,strong)PLPlayer *player;
@property(nonatomic,strong)FFT *fft;
@property(nonatomic,strong)SpectrumScrollView *spectrum;
@end
@implementation LMMusicPlayer
+ (LMMusicPlayer *)shared {
    if (acIndicator == nil) {
        acIndicator = [[LMMusicPlayer alloc] init];
        // 初始化 PLPlayerOption 对象
        PLPlayerOption *option = [PLPlayerOption defaultOption];

        // 更改需要修改的 option 属性键所对应的值
        [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
        [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
        [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
        [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
        [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
        NSArray *mp3Array = [NSBundle pathsForResourcesOfType:@"mp3" inDirectory:[[NSBundle mainBundle] resourcePath]];
        for (NSString *filePath in mp3Array) {
            NSURL *url = [NSURL fileURLWithPath:filePath];
            NSString *MusicName = [filePath lastPathComponent];
            AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:url options:nil];
            NSLog(@"%@",mp3Asset);
            acIndicator.player = [PLPlayer playerWithURL:url option:option];
            
        }
        acIndicator.player.loopPlay = YES;
        acIndicator.player.delegate = self;
        
//        _spectrum = [[SpectrumScrollView alloc] initWithFrame:CGRectMake(0, 450, self.view.bounds.size.width, 80)];
//        [self.view addSubview:_spectrum];
//        _spectrum.contentSize = CGSizeMake(512, 80);
//        _spectrum.scale = 5;
//        _spectrum.delegate = self;
    }
    return acIndicator;
}

-(void)initFFT{
    self.fft = [[FFT alloc] init];
    [self.fft setupWithLog2n:10];
}


+(void)play{
    [acIndicator.player play];
}
+(void)stop{
    [acIndicator.player stop];
}
#pragma mark -
// 实现 <PLPlayerDelegate> 来控制流状态的变更
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
    // 除了 Error 状态，其他状态都会回调这个方法
  // 开始播放，当连接成功后，将收到第一个 PLPlayerStatusCaching 状态
  // 第一帧渲染后，将收到第一个 PLPlayerStatusPlaying 状态
  // 播放过程中出现卡顿时，将收到 PLPlayerStatusCaching 状态
  // 卡顿结束后，将收到 PLPlayerStatusPlaying 状态
    if (state == PLPlayerStatusPlaying) {
        [player stop];
    }
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    // 当发生错误，停止播放时，会回调这个方法
}

- (void)player:(nonnull PLPlayer *)player codecError:(nonnull NSError *)error {
  // 当解码器发生错误时，会回调这个方法
  // 当 videotoolbox 硬解初始化或解码出错时
  // error.code 值为 PLPlayerErrorHWCodecInitFailed/PLPlayerErrorHWDecodeFailed
  // 播发器也将自动切换成软解，继续播放
}


//- (nonnull AudioBufferList *)player:(nonnull PLPlayer *)player willAudioRenderBuffer:(nonnull AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(PLPlayerAVSampleFormat)sampleFormat {
//    
//    if (audioBufferList->mBuffers[0].mDataByteSize / audioBufferList->mBuffers[0].mNumberChannels < 2048) {
//        return audioBufferList;
//    }
//    
//    if (sampleFormat != PLPlayerAV_SAMPLE_FMT_S16) {
//        return audioBufferList;
//    }
//    
//    if (audioBufferList->mBuffers[0].mNumberChannels == 1) {
//        
//        SInt16 buff[1024] = {0};
//        memcpy(buff, audioBufferList->mBuffers[0].mData, 2048);
//        
//        // int型转浮点数
//        float fbuff[1024] = {0};
//        for (int i=0; i<1024; i++) {
//            fbuff[i] = buff[i] / 32768.0f * 10;
//        }
//        
//        // 执行fft
//        float outbuff[512] = {0};
//        [self.fft performfft:fbuff out:outbuff];
//        
//        // 转换成oc对象
//        NSMutableArray *spectrumData = [NSMutableArray new];
//        for (int i=0; i<512; i++) {
//            [spectrumData addObject:@(outbuff[i])];
//        }
//        
//        // 显示频率
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.spectrum setdata:spectrumData];
//        });
//    }else if (audioBufferList->mBuffers[0].mNumberChannels == 2) {
//        
//        // 处理双通道，以及int转float
//        float left[1024] = {0};
//        float right[1024] = {0};
//        SInt16 *buff = audioBufferList->mBuffers[0].mData;
//        for (int i=0; i<2048; i++) {
//            if (i%2==0) {
//                left[i/2] = buff[i] / 32768.0f * 10;
//            }else{
//                right[i/2] = buff[i] / 32768.0f * 10;
//            }
//        }
//        
//        // 执行fft
//        float outbuff[512] = {0};
//        [self.fft performfft:left out:outbuff];
//        
//        // 转换成oc对象
//        NSMutableArray *spectrumData = [NSMutableArray new];
//        for (int i=0; i<512; i++) {
//            [spectrumData addObject:@(outbuff[i])];
//        }
//        
//        // 显示频率
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.spectrum setdata:spectrumData];
//        });
//        
//    }else{
//        
//    }
//    
//    return audioBufferList;
//}

@end
