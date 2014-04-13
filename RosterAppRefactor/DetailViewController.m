//
//  DetailViewController.m
//  RosterAppRefactor
//
//  Created by Cole Bratcher on 4/12/14.
//  Copyright (c) 2014 Cole Bratcher. All rights reserved.
//

#import "DetailViewController.h"
#import "Person.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DataSource.h"


@interface DetailViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *firstNameField;

@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *twitterField;

@property (weak, nonatomic) IBOutlet UITextField *githubField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIActionSheet *myActionSheet;

@end

@implementation DetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstNameField.text = self.person.firstName;
    self.lastNameField.text = self.person.lastName;
    self.imageView.image = self.person.avatar;
    self.twitterField.text = self.person.twitter;
    self.githubField.text = self.person.github;
    
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.twitterField.delegate = self;
    self.githubField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPhoto:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.myActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", @"Take Photo", nil];
        
    } else {
        self.myActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Photo", nil];
    }
    
    [self.myActionSheet showInView:self.view];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.person.firstName = self.firstNameField.text;
    self.person.lastName = self.lastNameField.text;
    
    [self.dataSource save];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.firstNameField) {
        [self.scrollView setContentOffset:CGPointMake(50, self.firstNameField.frame.origin.y - 30) animated:YES];
    } else if (textField == self.lastNameField) {
        [self.scrollView setContentOffset:CGPointMake(50, self.lastNameField.frame.origin.y - 30) animated:YES];
    } else if (textField == self.twitterField) {
        [self.scrollView setContentOffset:CGPointMake(50, self.twitterField.frame.origin.y - 30) animated:YES];
    } else if (textField == self.githubField) {
        [self.scrollView setContentOffset:CGPointMake(50, self.githubField.frame.origin.y - 30) animated:YES];
    }

}

#pragma mark - UIActionSheetDelegate methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"]) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose Photo"]) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    } else {
        
        return;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)saveImageToPhotoLibrary
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
        
        [assetsLibrary writeImageToSavedPhotosAlbum:_imageView.image.CGImage
                                        orientation:ALAssetOrientationUp
                                    completionBlock:^(NSURL *assetURL, NSError *error) {
                                        if (error) {
                                            NSLog(@"Error Saving Image : %@", error.localizedDescription);
                                        }
                                    }];
    } else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Save Photo"
                                                            message:@"Authorization Status Not Granted"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        NSLog(@"Authorization Not Determined");
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.person.avatar = [info objectForKey:UIImagePickerControllerEditedImage];
    _imageView.image = self.person.avatar;
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Completed");
        [[DataSource sharedData] save];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [self saveImageToPhotoLibrary];
        }
    }];
}


@end
