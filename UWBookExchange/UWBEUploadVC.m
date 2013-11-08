//
//  UWBEUploadVC.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-7.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "UWBEUploadVC.h"
#import "UIImage+Scaling.h"

@interface UWBEUploadVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, commsDelegate>
@property (nonatomic, strong) IBOutlet UILabel *lbChooseAPhoto;
@property (nonatomic, strong) IBOutlet UIImageView *imgToUpload;
@property (nonatomic, strong) IBOutlet UIButton *btnPhotoLibrary;
@property (nonatomic, strong) IBOutlet UIButton *btnCamera;
@property (nonatomic, strong) IBOutlet UIButton *btnUpload;
@property (nonatomic, strong) IBOutlet UITextField *tfComment;
@property (nonatomic, strong) IBOutlet UILabel *lbProgress;
@property (nonatomic, strong) IBOutlet UIView *vProgressUpload;
@property (nonatomic, strong) IBOutlet UIProgressView *progressUpload;
@property (nonatomic, strong) IBOutlet UITextField *tfBookName;
@property (nonatomic, strong) IBOutlet UITextField *tfBookPrice;
@property (nonatomic, strong) IBOutlet UITextField *tfBookMajor;

@end

@implementation UWBEUploadVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_btnPhotoLibrary setEnabled:[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]];
    [_btnCamera setEnabled:[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]];
    _vProgressUpload.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)choosePhotoFromPhotoAlbum{
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentModalViewController:pickerVC animated:YES];
}

-(IBAction)createPhotoWithCamera{
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.navigationController presentModalViewController:pickerVC animated:YES];
}

-(IBAction)uploadImage{
    // Disable the Upload button to prevent multiple touches
	[_btnUpload setEnabled:NO];
    
	// Check that we have an image selected
	if (!_imgToUpload.image) {
		[[[UIAlertView alloc] initWithTitle:@"Upload Error"
									message:@"Please choose an image before uploading"
								   delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil] show];
		[_btnUpload setEnabled:YES];
		return;
	}
    
	// Check that we have a comment to go with the image
	if (_tfComment.text.length == 0) {
		[[[UIAlertView alloc] initWithTitle:@"Upload Error"
									message:@"Please provide a comment for the book before uploading"
								   delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil] show];
		[_btnUpload setEnabled:YES];
		return;
	}
    
    if (_tfBookName.text.length == 0) {
		[[[UIAlertView alloc] initWithTitle:@"Upload Error"
									message:@"Please provide a name of the book before uploading"
								   delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil] show];
		[_btnUpload setEnabled:YES];
		return;
	}
    
    if (_tfBookPrice.text.length == 0) {
		[[[UIAlertView alloc] initWithTitle:@"Upload Error"
									message:@"Please provide a price for the book before uploading"
								   delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil] show];
		[_btnUpload setEnabled:YES];
		return;
	}
    
    if (_tfBookMajor.text.length == 0) {
		[[[UIAlertView alloc] initWithTitle:@"Upload Error"
									message:@"Please provide a Major name of the book before uploading"
								   delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil] show];
		[_btnUpload setEnabled:YES];
		return;
	}
	
	// Show progress
	[_vProgressUpload setHidden:NO];
    
    [comms uploadImage:self.imgToUpload.image withBookName:self.tfBookName.text withPrice:self.tfBookPrice.text withMajor:self.tfBookMajor.text withComment:self.tfComment.text forDelegate:self];
}

#pragma mark - UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [_lbChooseAPhoto setHidden:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
    [_imgToUpload setImage:[image imageScaledToFitSize:_imgToUpload.frame.size]];
}

#pragma mark - UITextViewDelegate

// Hide the keyboard when we return from the comment field.
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - commsDelegate


-(void)commsUploadImageFinished:(BOOL)success
{
	// Reset the UI
	[_vProgressUpload setHidden:YES];
	[_btnUpload setEnabled:YES];
	[_lbChooseAPhoto setHidden:NO];
	[_imgToUpload setImage:nil];
    
	// Did the upload work ?
	if (success) {
		[self.navigationController popViewControllerAnimated:YES];
	} else {
		[[[UIAlertView alloc] initWithTitle:@"Upload Error"
                                    message:@"Error uploading image. Please try again."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
	}
}


-(void)commsUploadImageProgress:(short)progress
{
	NSLog(@"Uploaded: %d%%", progress);
	[_progressUpload setProgress:(progress/100.0f)];
}

@end
