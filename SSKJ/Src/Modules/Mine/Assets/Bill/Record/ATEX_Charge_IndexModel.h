//
//  ATEX_Charge_IndexModel.h
//  SSKJ
//
//  Created by 刘小雨 on 2020/4/16.
//  Copyright © 2020 刘小雨. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATEX_Charge_IndexModel : NSObject
@property (nonatomic, copy) NSString *type;     // 1后台充值 2在线充值 3 OMNI钱包充值 4 ERC20钱包充值
@property (nonatomic, copy) NSString *wallet_address;   // 钱包地址
@property (nonatomic, copy) NSString *money;   // 充币数量
@property (nonatomic, copy) NSString *arrival_at;   // 到账时间
@property (nonatomic, copy) NSString *mark; //!< 充值说明

@end

NS_ASSUME_NONNULL_END
