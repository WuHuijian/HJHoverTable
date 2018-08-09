//
//  HJHoverTable.m
//  HJHoverTable
//
//  Created by WHJ on 2018/8/8.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import "HJHoverTable.h"
#import <Masonry/Masonry.h>

@interface HJHoverTable ()<UITableViewDelegate>

@property (nonatomic ,assign) CGFloat lastTop;

@property (nonatomic, assign) CGFloat hoverHeaderH;

@property (nonatomic ,strong) HJGestureTable * tableView;

@property (nonatomic ,strong) UIView * hoverHeader;

@property (nonatomic ,strong) UIView * wrapperView;

@property (nonatomic ,assign) BOOL isHover;//是否悬停

@property (nonatomic, assign) HJTopLimit topLimit;

@end

@implementation HJHoverTable
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self startConfig];
    }
    return self;
}



-(instancetype)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        [self startConfig];
    }
    return self;
}


- (void)startConfig
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.scrollEnabled = YES;
    self.alwaysBounceVertical = YES;
    
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:panG];
    [self addSubview:self.wrapperView];
}
#pragma mark - About UI
- (void)setupViews
{
    if(self.hoverHeader){
        [self.wrapperView addSubview:self.hoverHeader];
    }
    
    if (self.tableView) {
        [self.wrapperView addSubview:self.tableView];
    }
}


- (void)makeLayout
{
    if (self.hoverHeader) {
        [self.hoverHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.hoverHeaderH);
        }];
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.hoverHeader.mas_bottom);
        }];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
}


- (void)layoutSubviews
{
    //scrollView的subview.frame == scrollView.bounds的时候 无法滚动
    self.wrapperView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-1);
}
#pragma mark - Envet Response
- (void)panAction:(UIPanGestureRecognizer *)panG
{
    //计算偏移量
    CGFloat offsetY = [panG translationInView:self.superview].y;
    CGFloat finalTop = self.lastTop + offsetY;

    //条件限制 滑动上限
    if(finalTop <= self.topLimit.hoverTop && offsetY < 0){//向上
        finalTop = self.topLimit.hoverTop;
        self.isHover = YES;
        self.bounces = NO;
    }else if (finalTop <= self.topLimit.hoverTop && offsetY > 0){//向下
        if (CGPointEqualToPoint(self.tableView.contentOffset, CGPointZero)) {
            self.isHover = NO;
            self.bounces = YES;
        }else{
            finalTop = self.topLimit.hoverTop;
            self.isHover = YES;
            self.bounces = NO;
        }
    }else{
        self.isHover = NO;
        self.bounces = YES;
    }

    //条件限制 滑动下限
    if (finalTop>=self.topLimit.originTop && offsetY>0){//向下
        finalTop = self.topLimit.originTop;
    }
    
    //NSLog(@"offsetY = %.2f finalTop = %.2f",offsetY,finalTop);
    //修改布局
    [UIView animateWithDuration:0.25 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(finalTop);
        }];
    }];
    
    //滑动结束后记录上次位置
    if (panG.state == UIGestureRecognizerStateEnded){
        self.lastTop = finalTop;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [[change objectForKey:@"new"] CGPointValue];
        if (!self.isHover) {
            //当未悬停时 禁止table滑动
            //此处不设置scrollEnable是因为禁止滚动后需要第两次操作才能滑动 会导致交互不顺畅
            if (!CGPointEqualToPoint(offset, CGPointZero)) {
                self.tableView.contentOffset = CGPointMake(0, 0);
            }
        }
    }
}
#pragma mark - Public Methods
- (void)reloadData
{
    //移除之前的监听
    if (self.tableView) {
        [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    //代理调用
    if ([self.hoverTableDelegate respondsToSelector:@selector(headerOfHoverTable)]) {
        self.hoverHeader = [self.hoverTableDelegate headerOfHoverTable];
    }
    
    if ([self.hoverTableDelegate respondsToSelector:@selector(headerHOfHoverTable)]) {
        self.hoverHeaderH = [self.hoverTableDelegate headerHOfHoverTable];
    }
    
    if ([self.hoverTableDelegate respondsToSelector:@selector(gestureTable)]) {
        self.tableView = [self.hoverTableDelegate gestureTable];
    }
    
    if ([self.hoverTableDelegate respondsToSelector:@selector(limitOfMarginTop)]) {
        self.topLimit = [self.hoverTableDelegate limitOfMarginTop];
    }
    //设置UI
    [self setupViews];
    [self makeLayout];
    
    //刷新数据
    [self.tableView reloadData];
}


#pragma mark - Setters
- (void)setTableView:(HJGestureTable *)tableView
{
    _tableView = tableView;
    if (self.tableDelegate) {
        _tableView.delegate = self.tableDelegate;
    }
    
    if (self.tableDataSource) {
        _tableView.dataSource = self.tableDataSource;
    }
    
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setTopLimit:(HJTopLimit)topLimit
{
    _topLimit = topLimit;
    if (self.lastTop == 0) {
        self.lastTop = topLimit.originTop;
    }
}
#pragma mark - Getters
- (UIView *)wrapperView
{
    if (!_wrapperView) {
        _wrapperView = [UIView new];
        _wrapperView.backgroundColor = [UIColor whiteColor];
    }
    return _wrapperView;
}


#pragma mark - UIGestureRecognizerDelegate
// 允许处理多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
