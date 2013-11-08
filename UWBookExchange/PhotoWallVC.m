//
//  PhotoWallVC.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-4.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "PhotoWallVC.h"
#import "UWBEUploadVC.h"
#import "bookCommentCell.h"
#import "bookImgCell.h"
#import "commentPublishCell.h"

@interface PhotoWallVC ()<commsDelegate>{
    NSDate *_lastImageUpdate;
    NSDateFormatter *_commDateFormatter;
}
@end

@implementation PhotoWallVC

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem setTitleView:[[NavigationTitleView alloc] initWithTitle:@"ImageWall"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"bookImgCell" bundle:nil] forCellReuseIdentifier:@"bookImgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"bookCommentCell" bundle:nil] forCellReuseIdentifier:@"bookCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"commentPublishCell" bundle:nil] forCellReuseIdentifier:@"commentPublishCell"];
    _lastImageUpdate = [NSDate distantPast];
    _commDateFormatter = [[NSDateFormatter alloc] init];
    [_commDateFormatter setDateFormat:@"MMM d, h:mm a"];
    [comms getBookImagesSince:_lastImageUpdate forDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownLoaded:) name:N_ImageDownloaded object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [logoutBtn setTitle:@"logout" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [logoutBtn addTarget:self action:@selector(userLogout) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutBtn];
    
    UIButton *uploadPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [uploadPhotoBtn setTitle:@"upload" forState:UIControlStateNormal];
    [uploadPhotoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uploadPhotoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [uploadPhotoBtn addTarget:self action:@selector(uploadPhoto) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:uploadPhotoBtn];
    
}

-(void)userLogout{
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)uploadPhoto{
    UWBEUploadVC* vc = [[UWBEUploadVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)imageDownLoaded:(NSNotification *)notification{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[DataStore sharedInstance].bookImgs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString* bookImgCellIdentifier = @"bookImgCell";
    bookImgCell* cell = (bookImgCell *)[tableView dequeueReusableCellWithIdentifier:bookImgCellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"bookImgCell" owner:self options:nil];
        cell = (bookImgCell *)[topLevelObjects objectAtIndex:0];
    }
    bookImgInfo *bookImg = [[DataStore sharedInstance].bookImgs objectAtIndex:section];
    [cell.bookPic setImage:bookImg.image];
    [cell.userName setText:bookImg.user.username];
    [cell.seedDate setText:[_commDateFormatter stringFromDate:bookImg.createdDate]];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"bookCommentCell";
    bookCommentCell* cell = (bookCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - commsDelegate
-(void)commsDidGetNewBookImages:(NSDate *)updated{
    _lastImageUpdate = updated;
    [self.tableView reloadData];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
