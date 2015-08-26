#import "TGModernGalleryVideoItem.h"

@interface TGSecretPeerMediaGalleryVideoItem : TGModernGalleryVideoItem

@property (nonatomic, readonly) int32_t messageId;
@property (nonatomic, readonly) int64_t peerId;
@property (nonatomic) NSTimeInterval messageCountdownTime;
@property (nonatomic) NSTimeInterval messageLifetime;

- (instancetype)initWithVideoMedia:(TGVideoMediaAttachment *)videoMedia peerId:(int64_t)peerId messageId:(int32_t)messageId messageCountdownTime:(NSTimeInterval)messageCountdownTime messageLifetime:(NSTimeInterval)messageLifetime;

@end
