////
////  CreateGiffFirstVC.m
////  GiffPlugApp
////
////  Created by Kshitij Godara on 08/01/16.
////  Copyright © 2016 Kshitij Godara. All rights reserved.
////
//
//#pragma mark-
//@import FirebaseAnalytics;
//
//
//@interface UIImage (fixOrientation)
//
//- (UIImage *)fixOrientation;
//
//@end
//
//
//@implementation UIImage (fixOrientation)
//
//- (UIImage *)fixOrientation {
//    
//    // No-op if the orientation is already correct
//    if (self.imageOrientation == UIImageOrientationUp) return self;
//    
//    // We need to calculate the proper transformation to make the image upright.
//    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    switch (self.imageOrientation) {
//        case UIImageOrientationDown:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//            
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//            break;
//            
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//            break;
//        case UIImageOrientationUp:
//        case UIImageOrientationUpMirrored:
//            break;
//    }
//    
//    switch (self.imageOrientation) {
//        case UIImageOrientationUpMirrored:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//        case UIImageOrientationUp:
//        case UIImageOrientationDown:
//        case UIImageOrientationLeft:
//        case UIImageOrientationRight:
//            break;
//    }
//    
//    // Now we draw the underlying CGImage into a new context, applying the transform
//    // calculated above.
//    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
//                                             CGImageGetBitsPerComponent(self.CGImage), 0,
//                                             CGImageGetColorSpace(self.CGImage),
//                                             CGImageGetBitmapInfo(self.CGImage));
//    CGContextConcatCTM(ctx, transform);
//    switch (self.imageOrientation) {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            // Grr...
//            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
//            break;
//            
//        default:
//            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
//            break;
//    }
//    
//    // And now we just create a new UIImage from the drawing context
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//    UIImage *img = [UIImage imageWithCGImage:cgimg];
//    CGContextRelease(ctx);
//    CGImageRelease(cgimg);
//    return img;
//}
//
//@end
//#import "CreateGiffFirstVC.h"
//#import "PhotoPickerController.h"
//
//static void * CapturingStillImageContext = &CapturingStillImageContext;
//static void * SessionRunningContext = &SessionRunningContext;
//static void * mediaDurationContext = &mediaDurationContext;
//
//typedef NS_ENUM( NSInteger, AVCamSetupResult ) {
//    AVCamSetupResultSuccess,
//    AVCamSetupResultCameraNotAuthorized,
//    AVCamSetupResultSessionConfigurationFailed
//};
//
//typedef NS_ENUM( NSInteger, PictureMode ) {
//    PictureModeStopMotion,
//    PictureModeBurst,
//    PictureModeVideo
//};
//
//
//@interface CreateGiffFirstVC ()
//{
//    UILongPressGestureRecognizer *tapAndHoldGesture;
//    
//    NSMutableArray *imageArray;
//    UIImage *thumbnailImage;
//    NSTimer* holdTimer;
//    NSTimer *brustTimer;
//    //STOP MOTION;
//    NSTimer *stopMotionTimer;
//    NSTimer *stopMotionProgressTimer;
//    NSInteger stopMotionCounter;
//    BOOL isStopMotionCompleted, isStopMotionPaused;
//    NSInteger brustCounter;
//    
//    BOOL isVideo;
//    BOOL isStopMotion;
//    NSString *localFileP;
//    PictureMode pictureMode;
//    
//    CGFloat distanceOfButtons;
//}
//// For use in the storyboards.
//@property (nonatomic, weak) IBOutlet AAPLPreviewView *previewView;
//
//// Session management.
//@property (nonatomic) dispatch_queue_t sessionQueue;
//@property (nonatomic) AVCaptureSession *session;
//@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
//@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
//@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;
//
//// Utilities.
//@property (nonatomic) AVCamSetupResult setupResult;
//@property (nonatomic, getter=isSessionRunning) BOOL sessionRunning;
//@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
//@property (weak, nonatomic) IBOutlet UIImageView *gridImageView;
//@property (weak, nonatomic) IBOutlet UIButton *galleryOpenButton;
//- (IBAction)onGalleryOpenAction:(id)sender;
//
//- (void)removeDirectories;
//
//- (void)onCaptureStopMotion;
//
//- (void)resetCurrentView;
//
//@end
//
//@implementation CreateGiffFirstVC
//
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"kGoToPostScreen" object:nil];
//    //    [self removeObservers];
//}
//#pragma mark - View Life Cycle
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    //set navigation properties
//    
//    
//    
//    //FIX_LAY_OUT_ISSUE
//    
//    
//    pictureMode = PictureModeBurst;
//    
//    [_progresViewHeightCons setConstant:4*(SCREEN_WIDTH/320)];
//    
//    
//    [self setNavigationProperties];
//    imageArray = [[NSMutableArray alloc] init];
//    
//    
//    
//    _takePictureBtn.enabled = NO;
//    
//    [[self.view viewWithTag:500] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dottedLine"]]];
//    [[self.view viewWithTag:501] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dottedLine"]]];
//    
//    // set initial camera setup
//    [self initialCameraSetup];
//    
//    if (self.isOpenForProfilePurpose)
//    {
//        [_cameraContolView viewWithTag:101].hidden = YES;
//        [_cameraContolView viewWithTag:102].hidden = YES;
//        _galleryOpenButton.hidden = YES;
//    }
//    else
//    {
//        [self swipemethod];
//    }
//    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"kGoToPostScreen" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goToPostScreen) name:@"kGoToPostScreen" object:nil];
//}
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    
//    [self resetCurrentView];
//    if (pictureMode != PictureModeStopMotion)
//    {
//        for (UIGestureRecognizer *gesture in self.takePictureBtn.gestureRecognizers)
//        {
//            [self.takePictureBtn removeGestureRecognizer:gesture];
//        }
//        self.nextButton.hidden = YES;
//        if (pictureMode == PictureModeBurst)
//        {
//            CGPoint contentOffset = CGPointZero;
//            [_optionsScrollView setContentOffset:contentOffset animated:YES];
//        }
//        else
//        {
//            CGPoint contentOffset = CGPointMake(CGRectGetMidX(_videoBtn.frame) - (CGRectGetWidth(_optionsScrollView.frame) / 2.0),0.0);
//            [_optionsScrollView setContentOffset:contentOffset animated:YES];
//        }
//    }
//    else
//    {
//        CGPoint contentOffset = CGPointMake(CGRectGetMidX(_stopMotionBtn.frame) - (CGRectGetWidth(_optionsScrollView.frame) / 2.0),0.0);
//        [_optionsScrollView setContentOffset:contentOffset animated:YES];
//    }
//    [_giffProgressView setProgress:0.0];
//    
//    [self startCameraRunning];
//    [self removeDirectories];
//    [self createFolder];
//    
//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//        switch (status) {
//            case PHAuthorizationStatusAuthorized:
//            {
//                [self performSelectorOnMainThread:@selector(getLastGifToDisplay) withObject:nil waitUntilDone:NO];
//                //                [self getLastGifToDisplay];
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }];
//    [NSUSERDEFAULTS removeObjectForKey:@"progressValue"];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    if (self.videoDeviceInput.device.hasTorch)
//    {
//        [self.videoDeviceInput.device lockForConfiguration:nil];
//        [self.videoDeviceInput.device setTorchMode:AVCaptureTorchModeOff];
//        [self.videoDeviceInput.device unlockForConfiguration];
//        [self.flashBtn setBackgroundImage:[UIImage imageNamed:@"Flash Off"] forState:UIControlStateNormal];
//    }
//}
//
//-(void)viewDidDisappear:(BOOL)animated
//{
//    dispatch_async( self.sessionQueue, ^{
//        if ( self.setupResult == AVCamSetupResultSuccess ) {
//            [self.session stopRunning];
//            [self removeObservers];
//        }
//    } );
//    //imageArray = nil;
//    [super viewDidDisappear:animated];
//    
//}
//
//#pragma mark - Orientation
//
//- (BOOL)shouldAutorotate
//{
//    // Disable autorotation of the interface when recording is in progress.
//    return ! self.movieFileOutput.isRecording;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    
//    // Note that the app delegate controls the device orientation notifications required to use the device orientation.
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    if ( UIDeviceOrientationIsPortrait( deviceOrientation ) || UIDeviceOrientationIsLandscape( deviceOrientation ) ) {
//        AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
//        previewLayer.connection.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
//    }
//}
//
//
//
//#pragma mark - Navigation Properties
//
//-(void)setNavigationProperties
//{
//    [CommonFunction hideNavigationBarFromController:self];
//}
//
//- (void)getLastGifToDisplay
//{
//    @autoreleasepool {
//        // Asset fetch options...
//        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
//        // creating sort descriptors for sorting based on creationdate of asset...
//        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//        
//        if (pictureMode == PictureModeVideo)
//        {
//            // Fetching total assets of type image...
//            PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:allPhotosOptions];
//            
//            __block PHAsset *lastGifAsset = nil;
//            
//            // Looping through the result and fetching only GIF...
//            for (NSInteger i =0; i<result.count; i++)
//            {
//                PHAsset *asset = (PHAsset *)result[i];
//                lastGifAsset = asset;
//            }
//            if (lastGifAsset)
//            {
//                PHImageRequestOptions *option = [PHImageRequestOptions new];
//                option.synchronous = YES;
//                PHImageManager *imageManager = [[PHImageManager alloc]init];
//                [imageManager requestImageForAsset:lastGifAsset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (result)
//                        {
//                            [self.galleryOpenButton setImage:result forState:UIControlStateNormal];
//                            self.galleryOpenButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
//                        }
//                    });
//                }];
//            }
//            else
//            {
//                [self.galleryOpenButton setImage:nil forState:UIControlStateNormal];
//            }
//        }
//        else
//        {
//            // Fetching total assets of type image...
//            PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
//            
//            __block PHAsset *lastGifAsset = nil;
//            // Looping through the result and fetching only GIF...
//            for (NSInteger i =0; i<result.count; i++)
//            {
//                PHAsset *asset = (PHAsset *)result[i];
//                NSString *dataUTI = [asset valueForKey: @"uniformTypeIdentifier"];
//                if ([dataUTI isEqualToString:@"com.compuserve.gif"])
//                {
//                    lastGifAsset = asset;
//                }
//            }
//            
//            if (lastGifAsset)
//            {
//                PHImageRequestOptions *option = [PHImageRequestOptions new];
//                option.synchronous = YES;
//                PHImageManager *imageManager = [[PHImageManager alloc]init];
//                [imageManager requestImageForAsset:lastGifAsset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (result)
//                        {
//                            [self.galleryOpenButton setImage:result forState:UIControlStateNormal];
//                            self.galleryOpenButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
//                        }
//                    });
//                }];
//            }
//            else
//            {
//                [self.galleryOpenButton setImage:nil forState:UIControlStateNormal];
//            }
//        }
//    };
//}
//
//- (void)goToPostScreen
//{
//    [[[self presentedViewController] presentedViewController]dismissViewControllerAnimated:YES completion:^{
//    }];
//    [[[self presentedViewController]view]setUserInteractionEnabled:NO];
//    [[self presentedViewController] dismissViewControllerAnimated:YES completion:nil];
//    
//    PostGiffScreen *pgs = [[PostGiffScreen alloc] initWithNibName:@"PostGiffScreen" bundle:nil];
//    pgs.isGifFromGallery = YES;
//    [self.navigationController pushViewController:pgs animated:NO];
//}
//
//#pragma mark - IBActions
//- (IBAction)cancelBtnPressed:(id)sender
//{
//    //Get selected pervious vc index
//    NSInteger previousSelectedVC = [NSUSERDEFAULTS integerForKey:@"previousSelectedVC"];
//    //Give Selected Index
//    
//    [APPDELEGATE.appTabBarController setSelectedIndex:previousSelectedVC];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [[UIApplication sharedApplication]setStatusBarHidden:NO];
//    }];
//    
//}
//
//#pragma mark - Memory Managment
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - AVCamera setup
//
//-(void)initialCameraSetup
//{
//    // Create the AVCaptureSession.
//    self.session = [[AVCaptureSession alloc] init];
//    
//    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    //        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
//    //    else
//    //        [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
//    
//    // Setup the preview view.
//    self.previewView.session = self.session;
//    
//    // Communicate with the session and other session objects on this queue.
//    self.sessionQueue = dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL );
//    
//    self.setupResult = AVCamSetupResultSuccess;
//    
//    // Check video authorization status. Video access is required and audio access is optional.
//    // If audio access is denied, audio is not recorded during movie recording.
//    switch ( [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] )
//    {
//        case AVAuthorizationStatusAuthorized:
//        {
//            // The user has previously granted access to the camera.
//            break;
//        }
//        case AVAuthorizationStatusNotDetermined:
//        {
//            // The user has not yet been presented with the option to grant video access.
//            // We suspend the session queue to delay session setup until the access request has completed to avoid
//            // asking the user for audio access if video access is denied.
//            // Note that audio access will be implicitly requested when we create an AVCaptureDeviceInput for audio during session setup.
//            dispatch_suspend( self.sessionQueue );
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^( BOOL granted ) {
//                if ( ! granted ) {
//                    self.setupResult = AVCamSetupResultCameraNotAuthorized;
//                }
//                dispatch_resume( self.sessionQueue );
//            }];
//            break;
//        }
//        default:
//        {
//            // The user has previously denied access.
//            self.setupResult = AVCamSetupResultCameraNotAuthorized;
//            break;
//        }
//    }
//    
//    // Setup the capture session.
//    // In general it is not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
//    // Why not do all of this on the main queue?
//    // Because -[AVCaptureSession startRunning] is a blocking call which can take a long time. We dispatch session setup to the sessionQueue
//    // so that the main queue isn't blocked, which keeps the UI responsive.
//    dispatch_async( self.sessionQueue, ^{
//        if ( self.setupResult != AVCamSetupResultSuccess ) {
//            return;
//        }
//        
//        self.backgroundRecordingID = UIBackgroundTaskInvalid;
//        NSError *error = nil;
//        
//        AVCaptureDevice *videoDevice = [CreateGiffFirstVC deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
//        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
//        
//        
//        if ( ! videoDeviceInput ) {
//            NSLog( @"Could not create video device input: %@", error );
//        }
//        
//        [self.session beginConfiguration];
//        
//        if ( [self.session canAddInput:videoDeviceInput] ) {
//            [self.session addInput:videoDeviceInput];
//            self.videoDeviceInput = videoDeviceInput;
//            
//            dispatch_async( dispatch_get_main_queue(), ^{
//                // Why are we dispatching this to the main queue?
//                // Because AVCaptureVideoPreviewLayer is the backing layer for AAPLPreviewView and UIView
//                // can only be manipulated on the main thread.
//                // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes
//                // on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
//                
//                // Use the status bar orientation as the initial video orientation. Subsequent orientation changes are handled by
//                // -[viewWillTransitionToSize:withTransitionCoordinator:].
//                
//                
//                
//                if (self.videoDeviceInput.device.hasTorch)
//                {
//                    self.flashBtn.enabled = YES;
//                }
//                else
//                {
//                    self.flashBtn.enabled = NO;
//                }
//                [self.flashBtn setBackgroundImage:[UIImage imageNamed:@"Flash Off"] forState:UIControlStateNormal];
//                
//                //                if (self.videoDeviceInput.device.isFlashAvailable) {
//                //
//                //                    self.flashBtn.enabled = YES;
//                //
//                //
//                //                    [self.flashBtn setBackgroundImage:[UIImage imageNamed:@"Flash Auto"] forState:UIControlStateNormal];
//                //                    [CreateGiffFirstVC setFlashMode:AVCaptureFlashModeAuto forDevice:self.videoDeviceInput.device];
//                //
//                //                }
//                //                else
//                //                {
//                //                    self.flashBtn.enabled = NO;
//                //                    [self.flashBtn setBackgroundImage:[UIImage imageNamed:@"Flash off"] forState:UIControlStateNormal];
//                //                    [CreateGiffFirstVC setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
//                //
//                //                }
//                //                [CreateGiffFirstVC setFocusMode:AVCaptureFocusModeContinuousAutoFocus forDevice:self.videoDeviceInput.device];
//                
//                UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
//                AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
//                if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
//                    initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
//                }
//                
//                AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
//                previewLayer.connection.videoOrientation = initialVideoOrientation;
//                
//                UITapGestureRecognizer *tapFocus = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapFocus:)];
//                tapFocus.numberOfTapsRequired = 1;
//                [self.previewView addGestureRecognizer:tapFocus];
//                
//                UITapGestureRecognizer *tapChangeView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapChangeCamera:)];
//                tapChangeView.numberOfTapsRequired = 2;
//                [self.previewView addGestureRecognizer:tapChangeView];
//                
//                [tapFocus requireGestureRecognizerToFail:tapChangeView];
//                
//            } );
//        }
//        else {
//            NSLog( @"Could not add video device input to the session" );
//            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
//        }
//        
//        //        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
//        //        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
//        //
//        //        if ( ! audioDeviceInput ) {
//        //            NSLog( @"Could not create audio device input: %@", error );
//        //        }
//        //
//        //        if ( [self.session canAddInput:audioDeviceInput] ) {
//        //            [self.session addInput:audioDeviceInput];
//        //        }
//        //        else {
//        //            NSLog( @"Could not add audio device input to the session" );
//        //        }
//        
//        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
//        if ( [self.session canAddOutput:movieFileOutput] ) {
//            [self.session addOutput:movieFileOutput];
//            AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
//            if ( connection.isVideoStabilizationSupported ) {
//                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
//            }
//            self.movieFileOutput = movieFileOutput;
//        }
//        else {
//            NSLog( @"Could not add movie file output to the session" );
//            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
//        }
//        
//        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//        
//        if ( [self.session canAddOutput:stillImageOutput] ) {
//            stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
//            [self.session addOutput:stillImageOutput];
//            self.stillImageOutput = stillImageOutput;
//        }
//        else {
//            NSLog( @"Could not add still image output to the session" );
//            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
//        }
//        // [self.session setSessionPreset:AVCaptureSessionPresetMedium];
//        [self.session commitConfiguration];
//    } );
//    
//}
//
//- (void)onTapChangeCamera:(UITapGestureRecognizer *)tapGesture
//{
//    if (tapGesture.state == UIGestureRecognizerStateEnded) {
//        [self changeCameraView];
//    }
//}
//
//- (void)onTapFocus:(UITapGestureRecognizer *)tapGesture
//{
//    if (tapGesture.state == UIGestureRecognizerStateEnded)
//    {
//        if (self.videoDeviceInput.device)
//        {
//            if ([self.videoDeviceInput.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus] && [self.videoDeviceInput.device isFocusPointOfInterestSupported])
//            {
//                NSError *error;
//                [self.videoDeviceInput.device lockForConfiguration:&error];
//                if (!error)
//                {
//                    CGPoint point = [tapGesture locationInView:tapGesture.view];
//                    [self createFocusBoxViewAtPoint:point];
//                    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
//                    CGPoint newPoint = [previewLayer captureDevicePointOfInterestForPoint:point];
//                    [self.videoDeviceInput.device setFocusPointOfInterest:newPoint];
//                    [self.videoDeviceInput.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
//                    [self.videoDeviceInput.device setExposurePointOfInterest:newPoint];
//                    [self.videoDeviceInput.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
//                    [self.videoDeviceInput.device unlockForConfiguration];
//                }
//            }
//        }
//    }
//}
//
//- (void)setLockfocus
//{
//    if (self.videoDeviceInput.device)
//    {
//        if ([self.videoDeviceInput.device isFocusModeSupported:AVCaptureFocusModeLocked])
//        {
//            NSError *error;
//            [self.videoDeviceInput.device lockForConfiguration:&error];
//            if (!error)
//            {
//                [self.videoDeviceInput.device setFocusMode:AVCaptureFocusModeLocked];
//                [self.videoDeviceInput.device setExposureMode:AVCaptureExposureModeLocked];
//                [self.videoDeviceInput.device unlockForConfiguration];
//            }
//        }
//    }
//}
//
//- (void)createFocusBoxViewAtPoint:(CGPoint)focusPoint
//{
//    UIView *focusBox = [self.previewView viewWithTag:201];
//    if (focusBox)
//    {
//        [focusBox removeFromSuperview],focusBox = nil;
//    }
//    focusBox = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80*SCREEN_XScale, 80*SCREEN_XScale)];
//    focusBox.tag = 201;
//    focusBox.center = focusPoint;
//    focusBox.layer.borderColor = [UIColor yellowColor].CGColor;
//    focusBox.layer.borderWidth = 1.0f;
//    [self.previewView addSubview:focusBox];
//    focusBox.transform=CGAffineTransformMakeScale(1.5, 1.5);
//    [UIView animateWithDuration:.2 animations:^{
//        focusBox.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [UIView animateWithDuration:1.5f animations:^{
//                focusBox.alpha=0.0f;
//            } completion:^(BOOL finished) {
//                if (finished)
//                {
//                    [self removeFocusBoxView];
//                }
//            }];
//        }
//    }];
//}
//
//- (void)removeFocusBoxView
//{
//    UIView *focusBox = [self.previewView viewWithTag:201];
//    if (focusBox)
//    {
//        [focusBox removeFromSuperview],focusBox = nil;
//    }
//}
//
//-(void)startCameraRunning
//{
//    dispatch_async( self.sessionQueue, ^{
//        switch ( self.setupResult )
//        {
//            case AVCamSetupResultSuccess:
//            {
//                // Only setup observers and start the session running if setup succeeded.
//                [self addObservers];
//                NSError *error;
//                [self.videoDeviceInput.device lockForConfiguration:&error];
//                if (!error)
//                {
//                    [self.session startRunning];
//                    [self.videoDeviceInput.device unlockForConfiguration];
//                }
//                self.sessionRunning = self.session.isRunning;
//                break;
//            }
//            case AVCamSetupResultCameraNotAuthorized:
//            {
//                dispatch_async( dispatch_get_main_queue(), ^{
//                    NSString *message = NSLocalizedString( @"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera" );
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
//                    [alertController addAction:cancelAction];
//                    // Provide quick access to Settings.
//                    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"Alert button to open Settings" ) style:UIAlertActionStyleDefault handler:^( UIAlertAction *action ) {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                    }];
//                    [alertController addAction:settingsAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                } );
//                break;
//            }
//            case AVCamSetupResultSessionConfigurationFailed:
//            {
//                dispatch_async( dispatch_get_main_queue(), ^{
//                    NSString *message = NSLocalizedString( @"Unable to capture media", @"Alert message when something goes wrong during capture session configuration" );
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
//                    [alertController addAction:cancelAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                } );
//                break;
//            }
//        }
//    } );
//    
//}
//#pragma mark - KVO and Notifications
//
//- (void)addObservers
//{
//    [self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:SessionRunningContext];
//    [self.stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:CapturingStillImageContext];
//    
//    
//    [self addObserver:self
//           forKeyPath:@"movieFileOutput.recording"
//              options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:mediaDurationContext];
//    //
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.videoDeviceInput.device];
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:self.session];
//    //    // A session can only run when the app is full screen. It will be interrupted in a multi-app layout, introduced in iOS 9,
//    //    // see also the documentation of AVCaptureSessionInterruptionReason. Add observers to handle these session interruptions
//    //    // and show a preview is paused message. See the documentation of AVCaptureSessionWasInterruptedNotification for other
//    //    // interruption reasons.
//    //
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStarted:) name:AVCaptureSessionDidStartRunningNotification object:self.session];
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionWasInterrupted:) name:AVCaptureSessionWasInterruptedNotification object:self.session];
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInterruptionEnded:) name:AVCaptureSessionInterruptionEndedNotification object:self.session];
//}
//
//- (void)removeObservers
//{
//    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self removeObserver:self forKeyPath:@"movieFileOutput.recording" context:mediaDurationContext];
//    [self.session removeObserver:self forKeyPath:@"running" context:SessionRunningContext];
//    [self.stillImageOutput removeObserver:self forKeyPath:@"capturingStillImage" context:CapturingStillImageContext];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ( context == CapturingStillImageContext ) {
//        BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
//        
//        if ( isCapturingStillImage ) {
//            dispatch_async( dispatch_get_main_queue(), ^{
//                self.previewView.layer.opacity = 0.0;
//                [UIView animateWithDuration:0.25 animations:^{
//                    self.previewView.layer.opacity = 1.0;
//                }];
//            } );
//        }
//    }
//    else if ( context == SessionRunningContext )
//    {
//        
//        
//        BOOL isSessionRunning = [change[NSKeyValueChangeNewKey] boolValue];
//        
//        dispatch_async( dispatch_get_main_queue(), ^{
//            
//            
//            // Only enable the ability to change camera if the device has more than one camera.
//            self.takePictureBtn.enabled = isSessionRunning && ( [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 1 );
//            //                        self.recordButton.enabled = isSessionRunning;
//            //                        self.stillButton.enabled = isSessionRunning;
//        } );
//    }
//    else if (context == mediaDurationContext)
//    {
//        dispatch_async([self sessionQueue], ^{ // Background task started
//            // While the movie is recording, update the progress bar
//            while ([[self movieFileOutput] isRecording]) {
//                double duration = CMTimeGetSeconds([[self movieFileOutput] recordedDuration]);
//                //    double time = CMTimeGetSeconds([[self movieFileOutput] maxRecordedDuration]);
//                CGFloat progress = (CGFloat) (duration /4.399);
//                dispatch_async(dispatch_get_main_queue(), ^{ // Here I dispatch to main queue and update the progress view.
//                    [self.giffProgressView setProgress:progress animated:YES];
//                    
//                    if (progress>=1.00) {
//                        
//                        [self.movieFileOutput stopRecording];
//                    }
//                });
//            }
//        });
//        //NSLog(@"media duration %f",CMTimeGetSeconds(_movieFileOutput.recordedDuration));
//        
//    }
//    else
//    {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
//
//-(void)sessionStarted:(NSNotification *)notification
//{
//    
//    // BOOL isSessionRunning = [change[NSKeyValueChangeNewKey] boolValue];
//    dispatch_async( dispatch_get_main_queue(), ^{
//        NSLog(@"started");
//        [self.view setAlpha:1.0];
//        // Only enable the ability to change camera if the device has more than one camera.
//    } );
//}
//
//- (void)subjectAreaDidChange:(NSNotification *)notification
//{
//    CGPoint devicePoint = CGPointMake( 0.5, 0.5 );
//    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
//}
//
//- (void)sessionRuntimeError:(NSNotification *)notification
//{
//    NSError *error = notification.userInfo[AVCaptureSessionErrorKey];
//    NSLog( @"Capture session runtime error: %@", error );
//    
//    // Automatically try to restart the session running if media services were reset and the last start running succeeded.
//    // Otherwise, enable the user to try to resume the session running.
//    if ( error.code == AVErrorMediaServicesWereReset ) {
//        dispatch_async( self.sessionQueue, ^{
//            if ( self.isSessionRunning ) {
//                [self.session startRunning];
//                self.sessionRunning = self.session.isRunning;
//            }
//            else {
//                dispatch_async( dispatch_get_main_queue(), ^{
//                } );
//            }
//        } );
//    }
//    else {
//        
//    }
//}
//
//- (void)sessionWasInterrupted:(NSNotification *)notification
//{
//    // In some scenarios we want to enable the user to resume the session running.
//    // For example, if music playback is initiated via control center while using AVCam,
//    // then the user can let AVCam resume the session running, which will stop music playback.
//    // Note that stopping music playback in control center will not automatically resume the session running.
//    // Also note that it is not always possible to resume, see -[resumeInterruptedSession:].
//    BOOL showResumeButton = NO;
//    
//    // In iOS 9 and later, the userInfo dictionary contains information on why the session was interrupted.
//    if ( notification.userInfo[AVCaptureSessionInterruptionReasonKey]!=nil) {
//        AVCaptureSessionInterruptionReason reason = [notification.userInfo[AVCaptureSessionInterruptionReasonKey] integerValue];
//        NSLog( @"Capture session was interrupted with reason %ld", (long)reason );
//        
//        if ( reason == AVCaptureSessionInterruptionReasonAudioDeviceInUseByAnotherClient ||
//            reason == AVCaptureSessionInterruptionReasonVideoDeviceInUseByAnotherClient ) {
//            showResumeButton = YES;
//        }
//        else if ( reason == AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps ) {
//            
//            [UIView animateWithDuration:0.25 animations:^{
//                //                self.cameraUnavailableLabel.alpha = 1.0;
//            }];
//        }
//    }
//    else {
//        NSLog(@"Capture session was interrupted");
//        showResumeButton = ( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive );
//    }
//    
//    if ( showResumeButton ) {
//        
//    }
//}
//
//- (void)sessionInterruptionEnded:(NSNotification *)notification
//{
//    NSLog( @"Capture session interruption ended" );
//    
//    
//}
//
//#pragma mark Device Configuration
//
//- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
//{
//    dispatch_async( self.sessionQueue, ^{
//        AVCaptureDevice *device = self.videoDeviceInput.device;
//        NSError *error = nil;
//        if ( [device lockForConfiguration:&error] ) {
//            // Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
//            // Call -set(Focus/Exposure)Mode: to apply the new point of interest.
//            if ( device.isFocusPointOfInterestSupported && [device isFocusModeSupported:focusMode] ) {
//                device.focusPointOfInterest = point;
//                device.focusMode = focusMode;
//            }
//            
//            if ( device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode] ) {
//                device.exposurePointOfInterest = point;
//                device.exposureMode = exposureMode;
//            }
//            
//            device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange;
//            [device unlockForConfiguration];
//        }
//        else {
//            NSLog( @"Could not lock device for configuration: %@", error );
//        }
//    } );
//}
//
//
//+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
//{
//    if ( device.hasFlash && [device isFlashModeSupported:flashMode] ) {
//        NSError *error = nil;
//        if ( [device lockForConfiguration:&error] ) {
//            device.flashMode = flashMode;
//            
//            [device unlockForConfiguration];
//        }
//        else {
//            NSLog( @"Could not lock device for configuration: %@", error );
//        }
//    }
//}
//
//+ (void)setFocusMode:(AVCaptureFocusMode)focusMode forDevice:(AVCaptureDevice *)device
//{
//    if ([device isFocusModeSupported:focusMode] ) {
//        NSError *error = nil;
//        if ( [device lockForConfiguration:&error] ) {
//            device.focusMode = focusMode;
//            
//            [device unlockForConfiguration];
//        }
//        else {
//            NSLog( @"Could not lock device for configuration: %@", error );
//        }
//    }
//}
//
//
//+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
//{
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
//    AVCaptureDevice *captureDevice = devices.firstObject;
//    
//    for ( AVCaptureDevice *device in devices ) {
//        if ( device.position == position ) {
//            captureDevice = device;
//            break;
//        }
//    }
//    
//    return captureDevice;
//}
//
//#pragma mark - Movie Recording
//
//-(void)toggleMovieRecording
//{
//    // Disable the Camera button until recording finishes, and disable the Record button until recording starts or finishes. See the
//    // AVCaptureFileOutputRecordingDelegate methods.
//    
//    
//    dispatch_async( self.sessionQueue, ^{
//        
//        if ( ! self.movieFileOutput.isRecording )
//        {
//            if ( [UIDevice currentDevice].isMultitaskingSupported ) {
//                // Setup background task. This is needed because the -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:]
//                // callback is not received until AVCam returns to the foreground unless you request background execution time.
//                // This also ensures that there will be time to write the file to the photo library when AVCam is backgrounded.
//                // To conclude this background execution, -endBackgroundTask is called in
//                // -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:] after the recorded file has been saved.
//                self.backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//            }
//            
//            // Update the orientation on the movie file output video connection before starting recording.
//            AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
//            AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
//            connection.videoOrientation = previewLayer.connection.videoOrientation;
//            
//            // Turn OFF flash for video recording.
//            //            [CreateGiffFirstVC setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
//            
//            // Start recording to a temporary file.
//            NSString *outputFileName = [NSProcessInfo processInfo].globallyUniqueString;
//            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[outputFileName stringByAppendingPathExtension:@"mov"]];
//            
//            Float64 maximumVideoLength = 5; //Whatever value you wish to set as the maximum, in seconds
//            int32_t prefferedTimeScale = 30; //Frames per second
//            
//            CMTime maxDuration = CMTimeMakeWithSeconds(maximumVideoLength, prefferedTimeScale);
//            
//            self.movieFileOutput.maxRecordedDuration = maxDuration;
//            
//            
//            
//            [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
//        }
//        else {
//            [self.movieFileOutput stopRecording];
//        }
//    } );
//    
//    
//}
//
//
//
//#pragma mark -  File Output Recording Delegate
//
//-(void)checkRecordingTime
//{
//    if (CMTimeGetSeconds(self.movieFileOutput.recordedDuration)>5.0) {
//        
//        [brustTimer invalidate];
//        brustTimer = nil;
//        [self.movieFileOutput stopRecording];
//    }
//}
//
//- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
//{
//    // Enable the Record button to let the user stop the recording.
//    dispatch_async( dispatch_get_main_queue(), ^{
//        
//    });
//}
//
//- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
//{
//    // Note that currentBackgroundRecordingID is used to end the background task associated with this recording.
//    // This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's isRecording property
//    // is back to NO — which happens sometime after this method returns.
//    // Note: Since we use a unique file path for each recording, a new recording will not overwrite a recording currently being saved.
//    UIBackgroundTaskIdentifier currentBackgroundRecordingID = self.backgroundRecordingID;
//    self.backgroundRecordingID = UIBackgroundTaskInvalid;
//    
//    dispatch_block_t cleanup = ^{
//        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
//        if ( currentBackgroundRecordingID != UIBackgroundTaskInvalid ) {
//            [[UIApplication sharedApplication] endBackgroundTask:currentBackgroundRecordingID];
//        }
//    };
//    
//    BOOL success = YES;
//    
//    if ( error ) {
//        NSLog( @"Movie file finishing error: %@", error );
//        success = [error.userInfo[AVErrorRecordingSuccessfullyFinishedKey] boolValue];
//    }
//    if ( success )
//    {
//        if (![NSUSERDEFAULTS objectForKey:@"progressValue"]) {
//            [NSUSERDEFAULTS setObject:[NSNumber numberWithFloat:1.0f] forKey:@"progressValue"];
//        }
//        NSLog(@"extension is %@",[[outputFileURL path]pathExtension]);
//        [self saveVideo:outputFileURL];
//        
//    }
//    else {
//        cleanup();
//    }
//    
//    // Enable the Camera and Record buttons to let the user switch camera and start another recording.
//    dispatch_async( dispatch_get_main_queue(), ^{
//        
//        NSLog(@"duration isggghh %f",CMTimeGetSeconds(self.movieFileOutput.recordedDuration));
//        
//        // Only enable the ability to change camera if the device has more than one camera.
//        self.changeCameraBtn.enabled = ( [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 1 );
//    });
//}
//
//
//#pragma mark - IBActions Bottom Controls
//
//- (IBAction)cameraActionBtns:(UIButton *)sender
//{
//    UIButton *btn = (UIButton *)sender;
//    NSLog(@"%ld",(long)btn.tag);
//    
//    if (btn.tag == 0)
//    {
//        if (pictureMode == PictureModeStopMotion)
//        {
//            return;
//        }
//        
//        CGPoint contentOffset = CGPointMake(CGRectGetMidX(_stopMotionBtn.frame) - (CGRectGetWidth(_optionsScrollView.frame) / 2.0),0.0);
//        [_optionsScrollView setContentOffset:contentOffset animated:YES];
//        pictureMode = PictureModeStopMotion;
//        [self getLastGifToDisplay];
//        
//        for (UIGestureRecognizer *gesture in self.takePictureBtn.gestureRecognizers)
//        {
//            [self.takePictureBtn removeGestureRecognizer:gesture];
//        }
//        
//        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onLongPressStopMotion:)];
//        
//        [self.takePictureBtn addGestureRecognizer:longPressGesture];
//        
//        isStopMotionPaused = NO;
//        [self resetCurrentView];
//    }
//    else if (btn.tag == 1)
//    {
//        if (pictureMode == PictureModeBurst)
//        {
//            return;
//        }
//        for (UIGestureRecognizer *gesture in self.takePictureBtn.gestureRecognizers)
//        {
//            [self.takePictureBtn removeGestureRecognizer:gesture];
//        }
//        
//        //Brust
//        CGPoint contentOffset = CGPointZero;
//        [_optionsScrollView setContentOffset:contentOffset animated:YES];
//        
//        isVideo = false;
//        isStopMotion = false;
//        
//        pictureMode = PictureModeBurst;
//        [self getLastGifToDisplay];
//        [self resetCurrentView];
//    }
//    else if (btn.tag == 2)
//    { if (pictureMode == PictureModeVideo)
//    {
//        return;
//    }
//        for (UIGestureRecognizer *gesture in self.takePictureBtn.gestureRecognizers)
//        {
//            [self.takePictureBtn removeGestureRecognizer:gesture];
//        }
//        
//        
//        CGPoint contentOffset = CGPointMake(CGRectGetMidX(_videoBtn.frame) - (CGRectGetWidth(_optionsScrollView.frame) / 2.0),0.0);
//        [_optionsScrollView setContentOffset:contentOffset animated:YES];
//        [self.takePictureBtn removeGestureRecognizer:tapAndHoldGesture];
//        isVideo = true;
//        isStopMotion = false;
//        pictureMode = PictureModeVideo;
//        [self getLastGifToDisplay];
//        
//        [self resetCurrentView];
//    }
//}
//
//- (IBAction)takePictureBtnPressed:(id)sender
//{
//    
//    if (self.setupResult == AVCamSetupResultCameraNotAuthorized)
//    {
//        NSString *message = NSLocalizedString( @"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera" );
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:cancelAction];
//        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"Alert button to open Settings" ) style:UIAlertActionStyleDefault handler:^( UIAlertAction *action ) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }];
//        [alertController addAction:settingsAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//        return;
//    }
//    
//    
//    switch (pictureMode) {
//        case PictureModeStopMotion:
//        {
//            return;
//        }
//            break;
//            
//        case PictureModeBurst:
//        {
//            _galleryOpenButton.enabled = NO;
//            [_progresViewHeightCons setConstant:4*(SCREEN_WIDTH/320)];
//            _takePictureBtn.enabled = NO;
//            imageArray = nil;
//            imageArray  =  [[NSMutableArray alloc] init];
//            brustCounter = 1;
//            brustTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(snapStillImage) userInfo:nil repeats:YES];
//        }
//            break;
//        case PictureModeVideo:
//        {
//            [_progresViewHeightCons setConstant:4*(SCREEN_WIDTH/320)];
//            if (self.movieFileOutput.isRecording) {
//                [self.movieFileOutput stopRecording];
//                [NSUSERDEFAULTS setObject:[NSNumber numberWithFloat:self.giffProgressView.progress] forKey:@"progressValue"];
//            }
//            else
//            {
//                [self toggleMovieRecording];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    
//}
//
//
//
//
//
//
//
//#pragma mark - One Stop Motion
//
//-(void)snapStillImageAtWill
//{
//    
//    if (brustCounter<=10) {
//        
//        dispatch_async( self.sessionQueue, ^{
//            AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//            
//            AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
//            
//            // Update the orientation on the still image output video connection before capturing.
//            connection.videoOrientation = previewLayer.connection.videoOrientation;
//            
//            
//            // Flash set to Auto for Still Capture.
//            // [CreateGiffFirstVC setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
//            
//            // Capture a still image.
//            
//            [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^( CMSampleBufferRef imageDataSampleBuffer, NSError *error ) {
//                if ( imageDataSampleBuffer ) {
//                    // The sample buffer is not retained. Create image data before saving the still image to the photo library asynchronously.
//                    
//                    //                    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
//                    //                    NSLog(@" Metadata %@", (__bridge NSDictionary*)attachments);
//                    
//                    
//                    
//                    __block  NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                    
//                    dispatch_async( dispatch_get_main_queue(), ^{
//                        
//                        brustCounter = brustCounter +1;
//                        UIImage *wrongImage = [[UIImage alloc] initWithData:imageData];
//                        
//                        
//                        imageData = nil;
//                        
//                        NSData *compressedData = UIImageJPEGRepresentation(wrongImage,0.5);
//                        
//                        wrongImage = nil;
//                        wrongImage = [[UIImage alloc] initWithData:compressedData];
//                        
//                        UIImage *img =  [[wrongImage fixOrientation] copy];
//                        
//                        [imageArray addObject:img];
//                        
//                        [_giffProgressView setProgress:(float)brustCounter/10.0];
//                        NSLog(@"clicked %ld",(long)brustCounter);
//                        
//                        compressedData = nil;
//                        wrongImage = nil;
//                        
//                    } );
//                    
//                }
//                else {
//                    NSLog( @"Could not capture still image: %@", error );
//                    
//                }
//            }];
//            
//            
//        } );
//    }
//    else
//    {
//        NSLog(@"10 done image arrry count %lu",(unsigned long)imageArray.count);
//        
//    }
//    
//    
//    
//}
//
//#pragma mark - Brust Code
//
//-(void)snapStillImage
//{
//    if (brustCounter<6) {
//        
//        dispatch_async( self.sessionQueue, ^{
//            AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//            
//            AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
//            
//            // Update the orientation on the still image output video connection before capturing.
//            connection.videoOrientation = previewLayer.connection.videoOrientation;
//            
//            
//            // Flash set to Auto for Still Capture.
//            // [CreateGiffFirstVC setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
//            
//            // Capture a still image.
//            
//            [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^( CMSampleBufferRef imageDataSampleBuffer, NSError *error ) {
//                if ( imageDataSampleBuffer ) {
//                    // The sample buffer is not retained. Create image data before saving the still image to the photo library asynchronously.
//                    
//                    __block  NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                    
//                    dispatch_async( dispatch_get_main_queue(), ^{
//                        
//                        
//                        UIImage *wrongImage = [UIImage imageWithData:imageData];
//                        
//                        
//                        imageData = nil;
//                        
//                        [_giffProgressView setProgress:(float)brustCounter/5.0];
//                        
//                        brustCounter = brustCounter +1 ;
//                        
//                        UIImage *img =  [[wrongImage fixOrientation] copy];
//                        [imageArray addObject:@{@"image":img, @"order":[NSNumber numberWithInteger:brustCounter]}];
//                        
//                        if (imageArray.count==5) {
//                            
//                            thumbnailImage = [img squareAndSmallOfSize:CGSizeMake(180,180)];
//                        }
//                        
//                        wrongImage = nil;
//                    } );
//                }
//                else {
//                    NSLog( @"Could not capture still image: %@", error );
//                    
//                }
//            }];
//            
//            
//        } );
//        
//    }
//    else
//    {
//        
//        [NSUSERDEFAULTS setObject:[NSNumber numberWithFloat:1.0f] forKey:@"progressValue"];
//        [brustTimer invalidate];
//        brustTimer = nil;
//        CreateGifSecondVC *cgvc = [[CreateGifSecondVC alloc] initWithNibName:@"CreateGifSecondVC" bundle:nil];
//        cgvc.isOpenForProfilePurpose = self.isOpenForProfilePurpose;
//        cgvc.giffPartsImgArray = [imageArray copy];
//        cgvc.thumbnailSampleImg = [thumbnailImage copy];
//        [self.navigationController pushViewController:cgvc animated:YES];
//        thumbnailImage = nil;
//    }
//}
//
//
//#pragma mark - Create Giff
//
//
//-(void)createGiffFromImageArray
//{
//    NSDictionary *fileProperties = @{
//                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
//                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
//                                             }
//                                     };
//    
//    NSDictionary *frameProperties = @{
//                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
//                                              (__bridge id)kCGImagePropertyGIFDelayTime: @0.2f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
//                                              }
//                                      };
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
//    
//    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
//    
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",kAPPFOLDERNAME]];
//    
//    NSString *fullPath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"animated1.gif"]]; //add our image to the path
//    
//    
//    NSURL   *fileURL = [NSURL fileURLWithPath:fullPath isDirectory:NO];
//    
//    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, 5, NULL);
//    
//    for (UIImage *img in imageArray) {
//        
//        CGImageDestinationAddImage(destination, img.CGImage, (CFDictionaryRef)frameProperties);
//        
//    }
//    
//    
//    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
//    
//    
//    
//    if (!CGImageDestinationFinalize(destination)) {
//        NSLog(@"failed to finalize image destination");
//    }
//    else
//    {
//        CreateGifSecondVC *cgvc = [[CreateGifSecondVC alloc] initWithNibName:@"CreateGifSecondVC" bundle:nil];
//        cgvc.giffPartsImgArray = [imageArray copy];
//        
//        [self.navigationController pushViewController:cgvc animated:YES];
//        
//    }
//    CFRelease(destination);
//    
//    
//    
//    NSLog(@"url=%@", fileURL);
//    
//}
//
//
//#pragma mark - On/Off Camera Properties
//
//- (IBAction)setCameraProperties:(UIButton *)sender
//{
//    int myTag = (int)[sender tag];
//    
//    switch (myTag) {
//        case 1:
//        {
//            //Flash On/Off
//            
//            if (self.videoDeviceInput.device.hasTorch)
//            {
//                if (self.videoDeviceInput.device.isTorchAvailable)
//                {
//                    switch (self.videoDeviceInput.device.torchMode)
//                    {
//                        case AVCaptureTorchModeOff:
//                        {
//                            [self.videoDeviceInput.device lockForConfiguration:nil];
//                            [self.videoDeviceInput.device setTorchMode:AVCaptureTorchModeOn];
//                            [self.videoDeviceInput.device unlockForConfiguration];
//                            [self.flashBtn setBackgroundImage:[UIImage imageNamed:@"Flash On"] forState:UIControlStateNormal];
//                        }
//                            break;
//                            
//                        case AVCaptureTorchModeOn:
//                        {
//                            [self.videoDeviceInput.device lockForConfiguration:nil];
//                            [self.videoDeviceInput.device setTorchMode:AVCaptureTorchModeOff];
//                            [self.videoDeviceInput.device unlockForConfiguration];
//                            [self.flashBtn setBackgroundImage:[UIImage imageNamed:@"Flash Off"] forState:UIControlStateNormal];
//                        }
//                            break;
//                            
//                        case AVCaptureTorchModeAuto:
//                        {
//                            [self.videoDeviceInput.device lockForConfiguration:nil];
//                            [self.videoDeviceInput.device setTorchMode:AVCaptureTorchModeOn];
//                            [self.videoDeviceInput.device unlockForConfiguration];
//                            [self.flashBtn setBackgroundImage:[UIImage imageNamed:@"Flash On"] forState:UIControlStateNormal];
//                        }
//                            break;
//                            
//                        default:
//                            break;
//                    }
//                }
//            }
//        }
//            break;
//        case 2:
//        {
//            //Grid On/Off
//            if (self.gridImageView.isHidden)
//            {
//                self.gridImageView.hidden = NO;
//            }
//            else
//            {
//                self.gridImageView.hidden = YES;
//            }
//        }
//            break;
//        case 3:
//        {
//            //Front or back
//            if (self.setupResult == AVCamSetupResultCameraNotAuthorized)
//            {
//                NSString *message = NSLocalizedString( @"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera" );
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
//                [alertController addAction:cancelAction];
//                // Provide quick access to Settings.
//                UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"Alert button to open Settings" ) style:UIAlertActionStyleDefault handler:^( UIAlertAction *action ) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                }];
//                [alertController addAction:settingsAction];
//                [self presentViewController:alertController animated:YES completion:nil];
//                return;
//            }
//            if (self.videoDeviceInput.device.hasTorch)
//            {
//                [self.videoDeviceInput.device lockForConfiguration:nil];
//                [self.videoDeviceInput.device setTorchMode:AVCaptureTorchModeOff];
//                [self.videoDeviceInput.device unlockForConfiguration];
//                [self.flashBtn setBackgroundImage:[UIImage imageNamed:@"Flash Off"] forState:UIControlStateNormal];
//            }
//            [self changeCameraView];
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//}
//
//#pragma mark - Change Camera
//
//
//-(void)changeCameraView
//{
//    self.takePictureBtn.enabled = NO;
//    dispatch_async( self.sessionQueue, ^{
//        AVCaptureDevice *currentVideoDevice = self.videoDeviceInput.device;
//        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
//        AVCaptureDevicePosition currentPosition = currentVideoDevice.position;
//        
//        switch ( currentPosition )
//        {
//            case AVCaptureDevicePositionUnspecified:
//            case AVCaptureDevicePositionFront:
//            {
//                preferredPosition = AVCaptureDevicePositionBack;
//                
//            }
//                break;
//            case AVCaptureDevicePositionBack:
//                preferredPosition = AVCaptureDevicePositionFront;
//                break;
//        }
//        
//        AVCaptureDevice *videoDevice = [CreateGiffFirstVC deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
//        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
//        
//        [self.session beginConfiguration];
//        
//        // Remove the existing device input first, since using the front and back camera simultaneously is not supported.
//        [self.session removeInput:self.videoDeviceInput];
//        
//        if ( [self.session canAddInput:videoDeviceInput] ) {
//            //            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
//            //
//            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
//            
//            [self.session addInput:videoDeviceInput];
//            self.videoDeviceInput = videoDeviceInput;
//            
//            
//            
//            
//            //            if (self.videoDeviceInput.device.isFlashAvailable)
//            //            {
//            //                 [_flashBtn setEnabled:true];
//            //                if (self.videoDeviceInput.device.isFlashActive)
//            //                {
//            //
//            //                    [CreateGiffFirstVC setFlashMode:AVCaptureFlashModeOn forDevice:videoDevice];
//            //                }
//            //                else
//            //                {
//            //                    [CreateGiffFirstVC setFlashMode:AVCaptureFlashModeOff forDevice:videoDevice];
//            //
//            //                }
//            //
//            //            }
//            //            else
//            //            {
//            //                [_flashBtn setEnabled:false];
//            //            }
//        }
//        else {
//            [self.session addInput:self.videoDeviceInput];
//        }
//        
//        AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
//        if ( connection.isVideoStabilizationSupported ) {
//            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
//        }
//        
//        [self.session commitConfiguration];
//        
//        dispatch_async( dispatch_get_main_queue(), ^{
//            self.takePictureBtn.enabled = YES;
//            [self.flashBtn setBackgroundImage:[UIImage imageNamed:@"Flash Off"] forState:UIControlStateNormal];
//        } );
//    } );
//    
//}
//
//#pragma mark - Document Directory Methods
//
//- (IBAction)onGalleryOpenAction:(id)sender {
//    
//    //    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized)
//    //    {
//    PhotoPickerController *photoPicker = [[PhotoPickerController alloc]initWithNibName:NSStringFromClass([PhotoPickerController class]) bundle:nil];
//    photoPicker.type = (pictureMode == PictureModeVideo)?1:0;
//    [self.navigationController presentViewController:photoPicker animated:YES completion:nil];
//    //    }
//    //    else
//    //    {
//    //        [CommonFunction showAlertWithTitle:@"Gallery Permission" message:@"You have not enbaled permissions to access gallery" onViewController:self useAsDelegate:NO dismissBlock:nil];
//    //    }
//    
//    [FIRAnalytics logEventWithName:@"GifFromGallery"
//                        parameters:@{ }];
//}
//
//- (void)removeDirectories
//{
//    NSError *error;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",kAPPFOLDERNAME]];
//    
//    BOOL isDir;
//    if ([[NSFileManager defaultManager]fileExistsAtPath:dataPath isDirectory:&isDir])
//    {
//        [[NSFileManager defaultManager]removeItemAtPath:dataPath error:&error];
//    }
//}
//
//-(void)createFolder
//{
//    NSError *error;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",kAPPFOLDERNAME]];
//    
//    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
//    
//    // if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
//    
//}
//-(void)saveImage:(NSData *)imageData withImageName:(NSString*)imageName
//{
//    
//    NSError *error;
//    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
//    
//    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
//    
//    
//    
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",kAPPFOLDERNAME]];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
//        
//    }
//    NSString *folderPath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",kGIFFPARTSFOLDER]];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
//    }
//    
//    
//    
//    [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
//    
//    
//    NSString *fullPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg", imageName]]; //add our image to the path
//    
//    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
//    
//}
//-(void)videoFrame:(NSData *)imageData withImageName:(NSString*)imageName
//{
//    
//    NSError *error;
//    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
//    
//    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
//    
//    
//    
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",kAPPFOLDERNAME]];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
//        
//    }
//    NSString *folderPath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/VideoGiff"]];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
//        
//    }
//    NSString *framePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/VideoFrames"]];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:framePath])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:framePath withIntermediateDirectories:NO attributes:nil error:&error];
//        
//    }
//    
//    NSString *fullPath = [framePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg", imageName]]; //add our image to the path
//    
//    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
//    
//}
//
//-(void)saveVideo:(NSURL *)outputUrl
//{
//    NSString *filePath = [outputUrl path];
//    NSString *pathExtension = [filePath pathExtension] ;
//    if ([pathExtension length] > 0)
//    {
//        NSError *error;
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
//        
//        NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
//        
//        
//        
//        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",kAPPFOLDERNAME]];
//        
//        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
//        {
//            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
//            
//        }
//        NSString *folderPath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/VideoGiff"]];
//        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
//        {
//            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
//            
//        }
//        NSString *localFilePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [filePath lastPathComponent]]];
//        
//        // Method last path component is used here, so that each video saved will get different name.
//        
//        BOOL res = [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:localFilePath error:&error] ;
//        
//        if (!res)
//        {
//            NSLog(@"%@", [error localizedDescription]) ;
//        }
//        else
//        {
//            NSLog(@"File saved at : %@",localFilePath);
//            
//            localFileP = localFilePath;
//            UIVideoEditorController* videoEditor = [[UIVideoEditorController alloc] init];
//            videoEditor.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
//            videoEditor.delegate = self;
//            NSString* videoPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"MOV"];
//            if ( [UIVideoEditorController canEditVideoAtPath:localFilePath] ) {
//                videoEditor.videoPath = localFilePath;
//                videoEditor.videoMaximumDuration = 5.0;
//                [self presentViewController:videoEditor animated:YES completion:nil];
//            } else {
//                NSLog( @"can't edit video at %@", videoPath );
//            }
//        }
//    }
//}
//
//-(void)moveFileToNewLoction:(NSString *)fromPath
//{
//    //NSString *filePath = [outputUrl path];
//    NSString *pathExtension = [fromPath pathExtension] ;
//    if ([pathExtension length] > 0)
//    {
//        NSFileManager *fileManageer = [NSFileManager defaultManager];
//        
//        NSError *error;
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
//        
//        NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
//        
//        
//        
//        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",kAPPFOLDERNAME]];
//        
//        if (![fileManageer fileExistsAtPath:dataPath])
//        {
//            [fileManageer createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
//        }
//        NSString *folderPath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/VideoGiff"]];
//        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
//        {
//            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
//            
//        }
//        
//        
//        NSString *localFilePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"trimmedVideo.mov"]];
//        
//        // Method last path component is used here, so that each video saved will get different name.
//        
//        BOOL res = [fileManageer moveItemAtPath:fromPath toPath:localFilePath error:&error] ;
//        
//        if (!res)
//        {
//            NSLog(@"%@", [error localizedDescription]) ;
//        }
//        else
//        {
//            NSLog(@"File saved at : %@",localFilePath);
//            //[self getVideoFrames];
//            
//            __weak typeof(self) weakSelf = self;
//            
//            [NSGIF getGiffFrames:[NSURL fileURLWithPath:localFilePath] completion:^(NSMutableArray *frameArray){
//                
//                
//                CreateGifSecondVC *cgvc = [[CreateGifSecondVC alloc] initWithNibName:@"CreateGifSecondVC" bundle:nil];
//                [imageArray removeAllObjects];
//                for (NSInteger i=0; i<frameArray.count; i++)
//                {
//                    [imageArray addObject:@{@"image":frameArray[i], @"order":[NSNumber numberWithInteger:i]}];
//                }
//                cgvc.giffPartsImgArray = [imageArray copy];
//                cgvc.thumbnailSampleImg = [[frameArray lastObject] copy];
//                
//                [weakSelf.navigationController pushViewController:cgvc animated:YES];
//                
//                [weakSelf.presentedViewController dismissViewControllerAnimated:YES completion:^{
//                    [CommonFunction removeDirectories];
//                    [CommonFunction createFolder];
//                }];
//            }];
//            
//        }
//    }
//    
//}
//
//-(BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error movingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
//{
//    if ([error code] == NSFileWriteFileExistsError) //error code for: The operation couldn’t be completed. File exists
//        return YES;
//    else
//        return NO;
//    
//}
//
//
//#pragma mark - Video Editor Delegate
//
//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    // add done button to right side of nav bar
//    
//    for (UIView *view in navigationController.navigationBar.subviews)
//    {
//        if ([view isKindOfClass:[UIButton class]])
//        {
//            UIButton *btn = (UIButton *)view;
//            
//            if ([btn.titleLabel.text isEqualToString:@"Cancel"]) {
//                [btn setTintColor:[UIColor colorWithRed:228/255.0f green:15/255.0f blue:73/255.0f alpha:1.0f]];
//                [btn setImage:[UIImage imageNamed:@"CancelBtn"] forState:UIControlStateNormal];
//                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [btn setTitle:@"" forState:UIControlStateNormal];
//            }
//            else
//            {
//                [btn setTintColor:[UIColor colorWithRed:228/255.0f green:15/255.0f blue:73/255.0f alpha:1.0f]];
//                [btn setImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
//                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [btn setTitle:@"" forState:UIControlStateNormal];
//            }
//            
//        }
//    }
//    
//    [viewController.navigationItem setTitle:@"TRIM"];
//    
//}
//- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath
//{
//    // edited video is saved to a path in app's temporary directory
//    NSLog(@"edited video path %@ %@",editedVideoPath , localFileP);
//    [self moveFileToNewLoction:editedVideoPath];
//    
//}
//- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error
//{
//    
//}
//- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor
//{
//    [editor dismissViewControllerAnimated:YES completion:nil];
//    
//}
//
//#pragma mark - SwipeGesture Method
//
//-(void)swipemethod
//{
//    UISwipeGestureRecognizer *viewSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwipeGesture:)];
//    viewSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:viewSwipeGesture];
//    
//    UISwipeGestureRecognizer *viewSwipeGestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onSwipeGesture:)];
//    viewSwipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:viewSwipeGestureRight];
//    
//    distanceOfButtons = CGRectGetMidX(_brustBtn.frame) - CGRectGetMidX(_stopMotionBtn.frame);
//}
//
//#pragma mark -
//#pragma mark Swipe Camera Settings
//- (void)onSwipeGesture:(UISwipeGestureRecognizer *)gesture
//{
//    switch (gesture.direction) {
//        case UISwipeGestureRecognizerDirectionLeft:
//        {
//            switch (pictureMode) {
//                case PictureModeBurst:// Go to Video
//                {
//                    for (UIGestureRecognizer *gesture in _takePictureBtn.gestureRecognizers) {
//                        [_takePictureBtn removeGestureRecognizer:gesture];
//                    }
//                    pictureMode = PictureModeVideo;
//                    [self getLastGifToDisplay];
//                    CGPoint contentOffset = CGPointMake(CGRectGetMidX(_videoBtn.frame) - (CGRectGetWidth(_optionsScrollView.frame) / 2.0),0.0);
//                    [_optionsScrollView setContentOffset:contentOffset animated:YES];
//                    //                    [_optionsScrollView setContentOffset:CGPointMake(distanceOfButtons, 0.0) animated:YES];
//                    [self resetCurrentView];
//                }
//                    break;
//                case PictureModeStopMotion:// Go to Burst
//                {
//                    for (UIGestureRecognizer *gesture in _takePictureBtn.gestureRecognizers) {
//                        [_takePictureBtn removeGestureRecognizer:gesture];
//                    }
//                    pictureMode = PictureModeBurst;
//                    [_optionsScrollView setContentOffset:CGPointZero animated:YES];
//                    [self resetCurrentView];
//                }
//                    break;
//                case PictureModeVideo: // On video
//                {
//                    pictureMode = PictureModeVideo;
//                    // nothing...
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//            break;
//            
//        case UISwipeGestureRecognizerDirectionRight:
//        {
//            switch (pictureMode) {
//                case PictureModeBurst:// Go to Stop Motion
//                {
//                    pictureMode = PictureModeStopMotion;
//                    CGPoint contentOffset = CGPointMake(CGRectGetMidX(_stopMotionBtn.frame) - (CGRectGetWidth(_optionsScrollView.frame) / 2.0),0.0);
//                    [_optionsScrollView setContentOffset:contentOffset animated:YES];
//                    
//                    for (UIGestureRecognizer *gesture in self.takePictureBtn.gestureRecognizers)
//                    {
//                        [self.takePictureBtn removeGestureRecognizer:gesture];
//                    }
//                    
//                    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onLongPressStopMotion:)];
//                    [self.takePictureBtn addGestureRecognizer:longPressGesture];
//                    
//                    [self resetCurrentView];
//                }
//                    break;
//                case PictureModeStopMotion:// On Stop motion
//                {
//                    // return...
//                    pictureMode = PictureModeStopMotion;
//                    for (UIGestureRecognizer *gesture in self.takePictureBtn.gestureRecognizers)
//                    {
//                        [self.takePictureBtn removeGestureRecognizer:gesture];
//                    }
//                    
//                    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onLongPressStopMotion:)];
//                    [self.takePictureBtn addGestureRecognizer:longPressGesture];
//                }
//                    break;
//                case PictureModeVideo:// Go to Burst
//                {
//                    for (UIGestureRecognizer *gesture in _takePictureBtn.gestureRecognizers) {
//                        [_takePictureBtn removeGestureRecognizer:gesture];
//                    }
//                    pictureMode = PictureModeBurst;
//                    [self getLastGifToDisplay];
//                    [_optionsScrollView setContentOffset:CGPointZero animated:YES];
//                    
//                    [self resetCurrentView];
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
//}
//
//#pragma mark - ScrollView Method
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
//        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
//}
//
//#pragma mark - Get Video Frmaes
//
//-(void)getVideoFrames
//{
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:localFileP] options:nil];
//    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    generator.appliesPreferredTrackTransform = YES;
//    generator.requestedTimeToleranceAfter =  kCMTimeZero;
//    generator.requestedTimeToleranceBefore =  kCMTimeZero;
//    for (Float64 i = 0; i < CMTimeGetSeconds(asset.duration) *  30 ; i++){
//        @autoreleasepool {
//            CMTime time = CMTimeMake(i, 30);
//            NSError *err;
//            CMTime actualTime;
//            CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&err];
//            UIImage *generatedImage = [[UIImage alloc] initWithCGImage:image];
//            [self videoFrame:UIImageJPEGRepresentation(generatedImage,0.7) withImageName:[NSString stringWithFormat:@"imageFrameNo - %f",CMTimeGetSeconds(actualTime)]]; // Saves the image on document directory and not memory
//            CGImageRelease(image);
//        }
//    }
//    
//}
//
//#pragma mark -
//#pragma mark Stop Motion Long Press
//- (void)onLongPressStopMotion:(UILongPressGestureRecognizer *)gesture
//{
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//            
//            
//            if (self.setupResult == AVCamSetupResultCameraNotAuthorized)
//            {
//                NSString *message = NSLocalizedString( @"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera" );
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
//                [alertController addAction:cancelAction];
//                // Provide quick access to Settings.
//                UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"Alert button to open Settings" ) style:UIAlertActionStyleDefault handler:^( UIAlertAction *action ) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                }];
//                [alertController addAction:settingsAction];
//                [self presentViewController:alertController animated:YES completion:nil];
//                return;
//            }
//            
//            
//            if (!isStopMotionPaused)
//            {
//                _galleryOpenButton.enabled = NO;
//                
//                [_progresViewHeightCons setConstant:4*(SCREEN_WIDTH/320)];
//                isStopMotionCompleted = NO;
//                stopMotionCounter = 0;
//                _giffProgressView.progress = 1.0f;
//                
//                if (imageArray)
//                {
//                    [imageArray removeAllObjects];
//                }
//                else
//                {
//                    imageArray = [[NSMutableArray alloc]init];
//                }
//                
//                CGRect progressFrame = _giffProgressView.frame;
//                progressFrame.size.width = 0.0f;
//                //                progressFrame.size.height = (6/375.0)*SCREEN_WIDTH;
//                [_giffProgressView setFrame:progressFrame];
//                
//                [UIView animateWithDuration:4.5f delay:0.3f options:UIViewAnimationOptionCurveLinear animations:^{
//                    CGRect progressFrame = _giffProgressView.frame;
//                    progressFrame.size.width = self.view.frame.size.width;
//                    [_giffProgressView setFrame:progressFrame];
//                } completion:^(BOOL finished) {
//                    isStopMotionCompleted = YES;
//                    isStopMotionPaused = NO;
//                    if (finished)
//                    {
//                        isStopMotionCompleted = YES;
//                        [self onCaptureStopMotion];
//                    }
//                    else
//                    {
//                        isStopMotionCompleted = NO;
//                    }
//                }];
//                
//                stopMotionTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(onCaptureStopMotion) userInfo:nil repeats:YES];
//            }
//            else
//            {
//                stopMotionTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(onCaptureStopMotion) userInfo:nil repeats:YES];
//                [self performSelector:@selector(resumeAnimationsForView:) withObject:_giffProgressView afterDelay:0.3];
//            }
//        }
//            break;
//            
//        case UIGestureRecognizerStateEnded:
//        {
//            
//        }
//        case UIGestureRecognizerStateCancelled:
//        {
//            
//        }
//        case UIGestureRecognizerStateFailed:
//        {
//            
//            if (self.setupResult == AVCamSetupResultCameraNotAuthorized)
//            {
//                return;
//            }
//            
//            
//            if (isStopMotionCompleted)
//            {
//                return;
//            }
//            isStopMotionPaused = YES;
//            [self pauseAnimationsForView:_giffProgressView];
//            [stopMotionTimer invalidate];
//            //            isStopMotionCompleted = YES;
//        }
//            break;
//            
//        default:
//            break;
//    }
//}
//
//#pragma mark -
//#pragma mark Stop Motion Capture
//- (void)onCaptureStopMotion
//{
//    
//    if (isStopMotionCompleted)
//    {
//        
//        [NSUSERDEFAULTS setObject:[NSNumber numberWithFloat:1.0f] forKey:@"progressValue"];
//        isStopMotionPaused = NO;
//        [stopMotionTimer invalidate], stopMotionTimer = nil;
//        CreateGifSecondVC *cgvc = [[CreateGifSecondVC alloc] initWithNibName:@"CreateGifSecondVC" bundle:nil];
//        cgvc.giffPartsImgArray = [imageArray copy];
//        cgvc.thumbnailSampleImg = [thumbnailImage copy];
//        [self.navigationController pushViewController:cgvc animated:YES];
//        thumbnailImage = nil;
//        
//        return;
//    }
//    dispatch_async( self.sessionQueue, ^{
//        AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//        
//        AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
//        
//        // Update the orientation on the still image output video connection before capturing.
//        connection.videoOrientation = previewLayer.connection.videoOrientation;
//        
//        
//        // Flash set to Auto for Still Capture.
//        // [CreateGiffFirstVC setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
//        
//        // Capture a still image.
//        
//        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^( CMSampleBufferRef imageDataSampleBuffer, NSError *error ) {
//            if ( imageDataSampleBuffer ) {
//                // The sample buffer is not retained. Create image data before saving the still image to the photo library asynchronously.
//                
//                //                    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
//                //                    NSLog(@" Metadata %@", (__bridge NSDictionary*)attachments);
//                __block  NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                
//                dispatch_async( dispatch_get_main_queue(), ^{
//                    
//                    
//                    //  UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:imageData], nil,nil, nil);
//                    UIImage *wrongImage = [UIImage imageWithData:imageData];
//                    
//                    imageData = nil;
//                    
//                    stopMotionCounter += 1;
//                    
//                    
//                    UIImage *img =  [[wrongImage fixOrientation] copy];
//                    [imageArray addObject:@{@"image":img, @"order":[NSNumber numberWithInteger:stopMotionCounter]}];
//                    thumbnailImage = nil;
//                    thumbnailImage = [img squareAndSmallOfSize:CGSizeMake(180,180)];
//                    wrongImage = nil;
//                } );
//            }
//            else {
//                NSLog( @"Could not capture still image: %@", error );
//                
//            }
//        }];
//    } );
//}
//
//
//#pragma mark -
//#pragma mark Pause Animation
//- (void)pauseAnimationsForView:(UIView *)animatingView
//{
//    CFTimeInterval paused_time = [animatingView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
//    animatingView.layer.speed = 0.0;
//    animatingView.layer.timeOffset = paused_time;
//}
//
//#pragma mark -
//#pragma mark Resume Animation
//- (void)resumeAnimationsForView:(UIView *)animatingView
//{
//    CFTimeInterval paused_time = [animatingView.layer timeOffset];
//    animatingView.layer.speed = 1.0f;
//    animatingView.layer.timeOffset = 0.0f;
//    animatingView.layer.beginTime = 0.0f;
//    CFTimeInterval time_since_pause = [animatingView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - paused_time;
//    animatingView.layer.beginTime = time_since_pause;
//}
//
//#pragma mark -
//#pragma mark RESET VIEW
//- (void)resetCurrentView
//{
//    //    [self.view layoutIfNeeded];
//    
//    [NSUSERDEFAULTS removeObjectForKey:@"progressValue"];
//    if (pictureMode == PictureModeStopMotion)
//    {
//        self.nextButton.hidden = NO;
//        [_stopMotionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        [_brustBtn setTitleColor:[UIColor colorWithRed:1.0 green:33.0/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
//        
//        [_videoBtn setTitleColor:[UIColor colorWithRed:1.0 green:33.0/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
//    }
//    else
//    {
//        self.nextButton.hidden = YES;
//        if (pictureMode == PictureModeBurst)
//        {
//            [_brustBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            
//            [_stopMotionBtn setTitleColor:[UIColor colorWithRed:1.0 green:33.0/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
//            
//            [_videoBtn setTitleColor:[UIColor colorWithRed:1.0 green:33.0/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            
//            [_brustBtn setTitleColor:[UIColor colorWithRed:1.0 green:33.0/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
//            
//            [_stopMotionBtn setTitleColor:[UIColor colorWithRed:1.0 green:33.0/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
//        }
//    }
//    
//    [imageArray removeAllObjects];
//    [brustTimer invalidate],brustTimer=nil;
//    [stopMotionTimer invalidate],stopMotionTimer=nil;
//    
//    isStopMotionCompleted = NO;
//    isStopMotionPaused = NO;
//    
//    _takePictureBtn.enabled = YES;
//    _galleryOpenButton.enabled = YES;
//    
//    [_cameraContolView setUserInteractionEnabled:true];
//    
//    self.changeCameraBtn.enabled = YES;
//    
//    [self.movieFileOutput stopRecording];
//    
//    _giffProgressView.layer.speed = 1.0f;
//    [_giffProgressView.layer removeAllAnimations];
//    
//    _progresViewHeightCons.constant = 4.0f*(SCREEN_WIDTH/320);
//    [_giffProgressView setProgress:0.0f animated:NO];
//    [UIView animateWithDuration:.01 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        CGRect progressFrame = _giffProgressView.frame;
//        progressFrame.size.width = SCREEN_WIDTH;
//        [_giffProgressView setFrame:progressFrame];
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//}
//
//#pragma mark -
//#pragma mark Next Screen
//- (IBAction)onNextButton:(id)sender {
//    if (imageArray.count>0)
//    {
//        [stopMotionTimer invalidate], stopMotionTimer = nil;
//        CreateGifSecondVC *cgvc = [[CreateGifSecondVC alloc] initWithNibName:@"CreateGifSecondVC" bundle:nil];
//        cgvc.giffPartsImgArray = [imageArray copy];
//        cgvc.thumbnailSampleImg = [thumbnailImage copy];
//        [NSUSERDEFAULTS setObject:[NSNumber numberWithFloat:([_giffProgressView.layer.presentationLayer bounds].size.width/SCREEN_WIDTH)] forKey:@"progressValue"];
//        [self.navigationController pushViewController:cgvc animated:YES];
//        thumbnailImage = nil;
//    }
//}
//@end
