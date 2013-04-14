//
//  MainTableViewController.m
//  LAMApplicationForReview
//
//  Created by Anton Domashnev on 12.04.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "MainTableViewController.h"
#import "LAMPost+Network.h"
#import "LAMPostCell.h"
#import "MBProgressHUD+LAMStyle.h"
#import "LAMSelectTopicView.h"

@interface MainTableViewController ()<LAMSelectTopicViewDelegate>

@property (nonatomic, unsafe_unretained) CGFloat startContentOffset;
@property (nonatomic, unsafe_unretained) CGFloat lastContentOffset;
@property (nonatomic, unsafe_unretained) BOOL isNavigationBarHidden;

@property (nonatomic, strong) NSMutableArray *lamPostsArray;
@property (nonatomic, strong) NSMutableArray *showedLAMTopicPostsArray;

@property (nonatomic, strong) LAMSelectTopicView *selectTopicView;

@end

@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isNavigationBarHidden = NO;
    self.lamPostsArray = [NSMutableArray array];
    
    [self addSelectTopicView];
    [self loadPosts];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
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
    
    self.selectTopicView = [[LAMSelectTopicView alloc] initWithTopicsArray:[LAMPost loadedTopicsArray]
                                                                          inNavigationBar:self.navigationController.navigationBar];
    self.selectTopicView.delegate = self;
}

#pragma mark LAMSelectTopicViewDelegate

- (void)LAMSelectTopicView:(LAMSelectTopicView *)view didSelectTopic:(NSString *)topic{
    
    [self reloadData];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark UINavigationBarHidable

- (void)hideNavigationBar
{
    if(self.isNavigationBarHidden)
        return;
    
    self.isNavigationBarHidden = YES;

    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

- (void)showNavigationBar
{
    if(!self.isNavigationBarHidden)
        return;
    
    self.isNavigationBarHidden = NO;
    
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}

#pragma mark LAMPostCellAlpha

- (void)updateVisibleLAMPostCellsAlpha{
    
    NSArray *visibleCells = [self.tableView visibleCells];
    CGFloat screenYCenter = self.tableView.frame.origin.y + self.tableView.frame.size.height / 2;
    
    for(int row = 0; row < [visibleCells count]; row++){
        
        LAMPostCell *cell = visibleCells[row];
        CGFloat tableViewContentOffsetY = self.tableView.contentOffset.y;
        CGFloat cellCenterY = cell.frame.origin.y - tableViewContentOffsetY + cell.frame.size.height / 2;
        
        [cell updateAlphaForOffsetYFromScreenCenter: fabsf(screenYCenter - cellCenterY)];
    }
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startContentOffset = self.lastContentOffset = scrollView.contentOffset.y;
    
    [self.selectTopicView contract];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromStart = self.startContentOffset - currentOffset;
    CGFloat differenceFromLast = self.lastContentOffset - currentOffset;
    self.lastContentOffset = currentOffset;
    
    if((differenceFromStart) < 0)
    {
        // scroll up
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self hideNavigationBar];
    }
    else {
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self showNavigationBar];
    }
    
    [self updateVisibleLAMPostCellsAlpha];
}


@end
