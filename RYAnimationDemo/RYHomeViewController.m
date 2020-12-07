//
//  RYHomeViewController.m
//  RYAnimationDemo
//
//  Created by Leng,Guocheng on 2020/11/25.
//

#import "RYHomeViewController.h"
#import "RYAnimationDataHolder.h"
#import "RYAnimationDataModel.h"
#import "RYAnimationViewController.h"
@interface RYHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *animationListView;
@property (nonatomic, copy) NSArray *listData;
@end

@implementation RYHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _listData = [RYAnimationDataHolder getAnimationData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    [self.view addSubview:self.animationListView];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section > self.listData.count) {
        return nil;
    }
    UITableViewCell *cell = [_animationListView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableView class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableView class])];
        RYAnimationModel *model = self.listData[indexPath.section];
        cell.textLabel.text = model.animationName;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RYAnimationModel *model = self.listData[indexPath.section];
    RYAnimationViewController *vc = [[RYAnimationViewController alloc] initWithType:model.animationType];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter

- (UITableView *)animationListView {
    if (!_animationListView) {
        _animationListView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _animationListView.delegate = self;
        _animationListView.dataSource = self;
        _animationListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _animationListView;
}

@end
