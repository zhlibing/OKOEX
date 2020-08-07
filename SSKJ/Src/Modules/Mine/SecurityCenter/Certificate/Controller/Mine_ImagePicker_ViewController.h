//
//  BIImagePickerController.h
//  SSKJ
//
//  Created by 姚立志 on 2019/6/21.
//  Copyright © 2019 刘小雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Mine_ImagePickerControllerDelegate <NSObject>

-(void)didFinishPickingImage:(UIImage *_Nullable)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo;


@end

NS_ASSUME_NONNULL_BEGIN

@interface Mine_ImagePicker_ViewController : UIImagePickerController


/**
 设置类型
 
 @param type 1 为拍照  2 为相册
 @return 返回对象
 */
- (instancetype)initWithType:(NSInteger)type witDelegate:(id<Mine_ImagePickerControllerDelegate>)pickerDelegate;





@end

NS_ASSUME_NONNULL_END
