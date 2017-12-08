# XGMateData
配对数组：用于将对象配对到对应下标位置

<pre><code>
    NSArray *bottomBtnArr = @[@"标的详情",@"赎回记录",@"赎回",@"赎走",@"加息"];
 
    XGMateData *footerData; //底部视图
    XGMateData *moneyBoxFooterData; //储蓄罐底部视图
    XGMateData *btnTitleData;   //底部按钮
    

    btnTitleData = [bottomBtnArr mateDataWithIndex:2, nil];

    btnTitleData = [bottomBtnArr mateDataWithIndex:0,1,2,4, nil];

    btnTitleData = [bottomBtnArr mateDataWithIndex:0,1,3,4, nil];

    moneyBoxFooterData = [XGMateData mateData];
    footerData = [XGMateData mateData];
    
    XGMateData *data = [XGMateData dataWithObjects:@[self.titleArray[0], atrrBlock(amount,1)]];
    [section0Data addObject:data];
    
    XGMateData *data11 = [XGMateData dataWithObjects:@[self.titleArray[11], atrrBlock(interest,1)]];
    [section0Data addObject:data11];
   
    NSString *param = [NSString stringWithFormat:@"borrowId=%@",self.detailModel.idI];
    data1[2] = XG_JUMP_SHCEME(XG_JUMP_USEDCOUPON,param);
    [section0Data addObject:data1];
    
    //基础年化、年化收益
    NSString *rate;
    if (isBusiness) {
        rate = @"1";
    }else if(moneyBoxFooterData){
        rate = @"2";
    }else {
        rate = @"3";
    }
    XGMateData *data5 = [XGMateData dataWithObjects:@[self.titleArray[5], atrrBlock(rate,1)]];
    [section0Data addObject:data5];
    
    if (footerData) {
        NSString *endTime = [self.detailModel.time objectForKey:@"time"];
        if (endTime.length>0) {
            NSString *endTimeString = [GlobalUtil repaymentTimeWithInvestTime:endTime bidPeriodTime:self.detailModel.bidPeriod addDay:1];
            footerData[0] = endTimeString;
        }
        footerData[1] = interestPricipal;
        NSString *state;
        if([self.detailModel.status isEqualToString:@"3"]){
            state = @"已满标";
        }else if ([self.detailModel.status isEqualToString:@"4"]){
            state = @"计息中";
        }else if ([self.detailModel.status isEqualToString:@"5"]){
            state = @"已完成";
        }
        footerData[2] = state;
        [self initFooterView:footerData];
    }else if (moneyBoxFooterData) {
        if (self.detailModel.transferredAmount.floatValue >= 0.01) {
            moneyBoxFooterData[0] = @"11";
            moneyBoxFooterData[1] = timeString;
            moneyBoxFooterData[2] = @"33";
            
        }
        [self initMoneyBoxFooterView:moneyBoxFooterData];
    }
   </code></pre>
