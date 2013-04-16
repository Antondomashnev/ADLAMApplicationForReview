//
//  MainViewController.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 16.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "MainViewController.h"

#import "LAMPost+Network.h"
#import "LAMPostCell.h"
#import "MBProgressHUD+LAMStyle.h"
#import "LAMSelectTopicView.h"
#import "LAMDimView.h"

#define FULL_SCREEN_SCROLL_ANIMATION_DURATION .1
#define HIDDEN_SELECT_TOPIC_VIEW_ORIGIN_Y -44

@interface MainViewController ()<LAMSelectTopicViewDelegate>

@property (nonatomic, unsafe_unretained) float lastContentOffsetY;
@property (nonatomic, unsafe_unretained) BOOL isLAMSelectTopicViewHidden;

@property (nonatomic, strong) NSMutableArray *lamPostsArray;
@property (nonatomic, strong) NSMutableArray *showedLAMTopicPostsArray;

@property (nonatomic, strong) LAMSelectTopicView *selectTopicView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isLAMSelectTopicViewHidden = NO;
    self.lamPostsArray = [NSMutableArray array];
    
    [self addSelectTopicView];
    [self loadPosts];
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
     action:@selector(tap:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Gestures

- (void)tap:(UITapGestureRecognizer *)recogniser{
    
    [self.selectTopicView contract];
}

#pragma mark SelectTopicView

- (void)addSelectTopicView{
    
    self.selectTopicView = [[LAMSelectTopicView alloc] initWithTopicsArray:[LAMPost loadedTopicsArray]];
    self.selectTopicView.delegate = self;
    
    [self.view addSubview: self.selectTopicView];
}

#pragma mark LAMSelectTopicViewDelegate

- (void)LAMSelectTopicView:(LAMSelectTopicView *)view didSelectTopic:(NSString *)topic{
    
    [self reloadData];
}

- (void)LAMSelectTopicViewWillContract:(LAMSelectTopicView *)view{
    
    [LAMDimView hideFromView:self.tableView animated:YES];
}

- (void)LAMSelectTopicViewWillExpand:(LAMSelectTopicView *)view{
    
    [LAMDimView showInView:self.tableView animated:YES];
}

#pragma mark LoadPosts

- (void)loadPosts{
    
    [MBProgressHUD showLoadingHUDAddedTo:self.view animated:YES];
    
    [LAMPost loadPostsWithCallback:^(NSArray *objects, NSError *error) {
        
        if(!error){
            self.lamPostsArray = [objects mutableCopy];
            [self reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else{
            [MBProgressHUD showErrorHUDAddedTo:self.view withError:error animated:YES];
        }
    }];
}

- (void)reloadData{
    
    self.showedLAMTopicPostsArray = [[self.lamPostsArray filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"topic == %@", self.selectTopicView.selectedTopic]] mutableCopy];
    [self.tableView reloadData];
    [self updateVisibleLAMPostCellsAlpha];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LAMPostCell heightForCellWithAssociatedPost: self.lamPostsArray[indexPath.row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.showedLAMTopicPostsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"LAMPostCell";
    LAMPostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LAMPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.associatedPost = self.showedLAMTopicPostsArray[indexPath.row];
    return cell;
}

#pragma mark LayoutLAMSelectTopicView

- (void)hideLAMSelectTopicView
{
    if(self.isLAMSelectTopicViewHidden){
        return;
    }
    
    self.isLAMSelectTopicViewHidden = YES;
    
    __weak MainViewController *weakSelf = self;
    
    [UIView animateWithDuration:FULL_SCREEN_SCROLL_ANIMATION_DURATION animations:^{
        
        CGRect hiddenSelectTopicViewFrame = self.selectTopicView.frame;
        hiddenSelectTopicViewFrame.origin.y = HIDDEN_SELECT_TOPIC_VIEW_ORIGIN_Y;
        weakSelf.selectTopicView.frame = hiddenSelectTopicViewFrame;
        
        CGRect newTableViewRect = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height + hiddenSelectTopicViewFrame.size.height);
        weakSelf.tableView.frame = newTableViewRect;
    }];
}

- (void)showLAMSelectTopicView
{
    if(!self.isLAMSelectTopicViewHidden){
        return;
    }
    
    self.isLAMSelectTopicViewHidden = NO;
    
    __weak MainViewController *weakSelf = self;
    
    [UIView animateWithDuration:FULL_SCREEN_SCROLL_ANIMATION_DURATION animations:^{
        
        CGRect hiddenSelectTopicViewFrame = weakSelf.selectTopicView.frame;
        hiddenSelectTopicViewFrame.origin.y = 0;
        weakSelf.selectTopicView.frame = hiddenSelectTopicViewFrame;
        
        CGRect newTableViewRect = CGRectMake(0, hiddenSelectTopicViewFrame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height - hiddenSelectTopicViewFrame.size.height);
        weakSelf.tableView.frame = newTableViewRect;
    }];
}

- (void)layoutLAMSelectTopicViewWithDeltaY:(CGFloat)delatY{
    
    if(delatY <= 0){
        [self hideLAMSelectTopicView];
    }
    else{
        [self showLAMSelectTopicView];
    }
}

#pragma mark LAMPostCellAlpha

- (void)updateVisibleLAMPostCellsAlpha{
    
    NSArray *visibleCells = [self.tableView visibleCells];
    CGFloat screenYCenter = self.tableView.frame.origin.y + self.tableView.frame.size.height / 2;
    
    for(int row = 0; row < [visibleCells count]; row++){
        
        LAMPostCell *cell = visibleCells[row];
        CGFloat tableViewContentOffsetY = self.tableView.contentOffset.y;
        CGFloat cellCenterY = cell.frame.origin.y - tableViewContentOffsetY + cell.frame.size.height / 2;
        
        [cell updateAlphaForOffsetYFromScreenCenter: (screenYCenter - cellCenterY)];
    }
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(!self.isLAMSelectTopicViewHidden){
      [self.selectTopicView contract];  
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= scrollView.contentSize.height - self.view.frame.size.height) {
        if (self.lastContentOffsetY > scrollView.contentOffset.y) {

            [self showLAMSelectTopicView];
        }
        else if (self.lastContentOffsetY < scrollView.contentOffset.y) {
            
            [self hideLAMSelectTopicView];
        }
        
        self.lastContentOffsetY = scrollView.contentOffset.y;
    }
}

@end
