//
//  NavigationAnimationView.m
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/11/25.
//

#import "NavigationAnimationView.h"
#import "Masonry.h"
@interface NavigationAnimationView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, strong) UITableView *imageListView;
@property (nonatomic, copy) NSArray *cellData;
@end

@implementation NavigationAnimationView

- (instancetype)initWithFrame:(CGRect)frame AndParentVC:(UIViewController *)controller{
    if (self = [super initWithFrame:frame]) {
        _parentVC = controller;
        
        [self setUpSubViews];
        _cellData = @[@"dijia_01",@"dijia_02", @"aoteman_01", @"aoteman_02", @"zleb_01"];
        self.parentVC.navigationItem.title = @"导航栏动画";
        /**
         hidesBarsOnSwipe                               滑动隐藏
         hidesBarsOnTap                                   点击隐藏
         hidesBarsWhenKeyboardAppears       键盘输入时隐藏
         */
        self.parentVC.navigationController.hidesBarsOnSwipe = true;
    }
    return self;
}

- (void)setUpSubViews {
    [self addSubview:self.imageListView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.imageListView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableView class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableView class])];
        /**
         1    UITableViewCellAccessoryDisclosureIndicator    箭头
         2    UITableViewCellAccessoryDetailButton    帮助按钮
         3    UITableViewCellAccessoryCheckmark    打钩
         4    UITableViewCellAccessoryDetailDisclosureButton    帮助按钮 + 箭头
         5    UITableViewCellAccessoryNone    不显示辅助指示视图;默认
         */
        // 设置右边的指示样式
        cell.accessoryType = UITableViewCellAccessoryNone;

        // 设置cell的选中样式
        // 颜色就灰色和无色两种
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.cellData[indexPath.row]]];
    [cell.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

#pragma mark - getter
- (UITableView *)imageListView {
    if (!_imageListView) {
        _imageListView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _imageListView.delegate = self;
        _imageListView.dataSource = self;
        _imageListView.showsVerticalScrollIndicator = NO;
    }
    return _imageListView;
}




@end
