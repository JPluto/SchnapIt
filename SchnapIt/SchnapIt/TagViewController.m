//
//  TagViewController.m
//  SchnapIt
//
//  Created by David Way on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TagViewController.h"
#import "Constants.h"

@implementation TagViewController

@synthesize annotationView, dictionaryBox, addButton,deleteButton,colorArray;
@synthesize imageView = _imageView;
@synthesize topToolbar = _topToolbar;
@synthesize bottomToolbar = _bottomToolbar;
@synthesize doneButton = _doneButton;
@synthesize objectsListViewController = _objectsListViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        dictionaryBox = [[NSMutableDictionary alloc]init];
        colorArray=[[NSArray alloc] initWithObjects:[UIColor blueColor],[UIColor cyanColor],[UIColor greenColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor redColor],[UIColor yellowColor],[UIColor purpleColor],[UIColor brownColor], nil];
        Box *box = [[Box alloc]init];
        box.color=[UIColor blueColor];
        [dictionaryBox setObject:box forKey:[NSString stringWithFormat:@"%d",0]];
        numLabels=1;
        [box release];
     
        //  make the done button b/c the top navigation bar is not represented in the xib
        self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Look Up" 
                                                           style:UIBarButtonSystemItemDone 
                                                          target:self 
                                                          action:@selector(doneAction:)];
        
        //  annotationView = [[TagView alloc] initWithFrame:CGRectMake(0, 45, 320, 385)];
        
        
        // Custom initialization
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.objectsListViewController  = [[[ObjectsListViewController alloc] init] autorelease];
    // self.annotationView = [[TagView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    //[annotationView setDictionary:dictionaryBox];
    annotationView.dictionaryBox = self.dictionaryBox;
    //[annotationView setSelectedBox:0];
    selectedBox=0;
    
    self.title = @"Tag It!";
    
    [self.annotationView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.annotationView];
    //    [self.view addSubview:self.topToolbar];
    //    self.topToolbar.frame = CGRectMake(0,44, 320, 45);
    // //   NSLog(@"%f", self.view.frame.origin.y);
    // //   NSLog(@"%f", self.topToolbar.frame.origin.y);
    [self.view addSubview:self.bottomToolbar];
    
   // NSLog(@"highasoi");
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.doneButton, 
                                               nil];
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setImage:(UIImage *)image{
    
    NSLog(@"%f", self.view.frame.size.width);
    // self.imageView.image = [UIImage imageNamed:@"LabelMeIcon.png"];
    self.imageView.image = image;
    NSLog(@"%@",image);
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    Box *currentBox;// = [dictionaryBox objectForKey:[NSString stringWithFormat:@"%d",selectedBox]];
    /*if (keyboardVisible) {
     currentBox.label=label.text;
     [label resignFirstResponder];
     keyboardVisible=NO;
     //label.text=@"";
     
     return;
     }*/
    
    if ([annotationView SelectedBox]!=-1) {
        currentBox = [dictionaryBox objectForKey:[NSString stringWithFormat:@"%d",[annotationView SelectedBox]]];
        
        
        
        if ((CGRectContainsPoint(CGRectMake([currentBox upperLeft].x-2*LINEWIDTH, [currentBox upperLeft].y-2*LINEWIDTH,4*LINEWIDTH,4*LINEWIDTH) , location)))  {
            size=YES;
            corner = 1;
        }
        else if ((CGRectContainsPoint(CGRectMake([currentBox lowerRight].x-2*LINEWIDTH, [currentBox lowerRight].y-2*LINEWIDTH,4*LINEWIDTH,4*LINEWIDTH) , location)))  {
            size=YES;
            corner=4;
        }
        else if ((CGRectContainsPoint(CGRectMake([currentBox lowerRight].x-2*LINEWIDTH, [currentBox upperLeft].y-2*LINEWIDTH,4*LINEWIDTH,4*LINEWIDTH) , location)))  {
            size=YES;
            corner=2;
        }
        else if ((CGRectContainsPoint(CGRectMake([currentBox upperLeft].x-2*LINEWIDTH, [currentBox lowerRight].y-2*LINEWIDTH,4*LINEWIDTH,4*LINEWIDTH) , location)))  {
            size=YES;
            corner=3;
        }
        else if ((CGRectContainsPoint(CGRectMake([currentBox upperLeft].x-LINEWIDTH/2, [currentBox upperLeft].y-LINEWIDTH/2, [currentBox lowerRight].x-[currentBox upperLeft].x+LINEWIDTH, [currentBox lowerRight].y-[currentBox upperLeft].y+LINEWIDTH) , location))) {
            move=YES;
            firstLocation=location;
        }
        
        
        else{
            selectedBox=-1;
            [annotationView setSelectedBox:-1];
            self.deleteButton.enabled = false;
        }
    }
    
    
    else{
        int num = [dictionaryBox count];
        for (int i= 0; (i<num); i++){
            currentBox = [dictionaryBox objectForKey:[NSString stringWithFormat:@"%d",i]];
            if (CGRectContainsPoint(CGRectMake([currentBox upperLeft].x-LINEWIDTH, [currentBox upperLeft].y-LINEWIDTH, [currentBox lowerRight].x-[currentBox upperLeft].x+2*LINEWIDTH, [currentBox lowerRight].y-[currentBox upperLeft].y+2*LINEWIDTH) , location)) {
                selectedBox = i;
                [annotationView setSelectedBox:i];
                self.deleteButton.enabled = true;
                break;
            }
            
            
        }
        
    }
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    Box *currentBox = [dictionaryBox objectForKey:[NSString stringWithFormat:@"%d",selectedBox]];
    if (move) {
        [currentBox updatePoints:firstLocation :location];
        [dictionaryBox setObject:currentBox forKey:[NSString stringWithFormat:@"%d",selectedBox]];
        /*firstLocation=location;
         [self setNeedsDisplay];*/
        
    }
    
    else if (size){
        switch (corner) {
            case 1:
                corner+=[currentBox setUpperLeft:location];
                break;
            case 2:
                corner+=[currentBox setUpperLeft:CGPointMake([currentBox upperLeft].x, location.y)]-[currentBox setLowerRight:CGPointMake(location.x, [currentBox lowerRight].y)];
                break;
            case 3:
                corner+=[currentBox setUpperLeft:CGPointMake(location.x, [currentBox upperLeft].y)]-[currentBox setLowerRight:CGPointMake([currentBox lowerRight].x, location.y)];
                break;
            case 4:
                corner-=[currentBox setLowerRight:location];
                break;
                
            default:
                break;
        }
        /*if ((CGRectContainsPoint(CGRectMake([currentBox upperLeft].x-7.5, [currentBox upperLeft].y-7.5,[currentBox lowerRight].x-[currentBox upperLeft].x+15,15 ),firstLocation))| (CGRectContainsPoint(CGRectMake([currentBox upperLeft].x-7.5, [currentBox upperLeft].y-7.5,15,[currentBox lowerRight].y-[currentBox upperLeft].y+15) ,firstLocation))) {
         [currentBox updateUpperLeft:firstLocation :location];
         //NSLog(@"He tocado arriba o izquierda");
         }
         else{
         [currentBox updateLowerRight:firstLocation :location];
         //NSLog(@"He tocado abajo o derecha");
         
         }*/
        
    }
    firstLocation=location;
    [annotationView setNeedsDisplay];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    move=NO;
    size=NO;
    corner=0;
    [annotationView setNeedsDisplay];
}  

/*-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 Box *b;
 for (int i= 0; (i<[dictionaryBox count]); i++){
 b=[dictionaryBox objectForKey:[NSString stringWithFormat:@"%d",i]];
 NSLog(@"Label: %@",b.label);
 }
 
 }*/

-(IBAction)addAction:(id)sender{

    Box *box = [[Box alloc]init];
    box.color=[colorArray objectAtIndex:(numLabels%9)];
    [dictionaryBox setObject:box forKey:[NSString stringWithFormat:@"%d",numLabels]];
    [annotationView setSelectedBox:numLabels];
    selectedBox=numLabels;
    numLabels++;
    [annotationView setNeedsDisplay];
    if (numLabels>=2){
        self.addButton.enabled = false;
    }
    if (numLabels>0){
        self.deleteButton.enabled = true;
        
    }
    
    //NSLog(@"La cuenta es: %d",[dictionaryBox count]);
    
}

-(IBAction)labelFinish:(id)sender{
    if ([annotationView SelectedBox]!=-1) {
        Box *box = [dictionaryBox objectForKey:[NSString stringWithFormat:@"%d",[annotationView SelectedBox]]];
        for (int i=0; i<[dictionaryBox count]; i++) {
            if (i==[annotationView SelectedBox]) {
                continue;
            }
            Box *b=[dictionaryBox objectForKey:[NSString stringWithFormat:@"%d",i]];
            if ([box.label isEqualToString:b.label]) {
                box.color=b.color;
                [annotationView setNeedsDisplay];
                break;
                
            }
            // release??
        }
        [dictionaryBox setObject:box forKey:[NSString stringWithFormat:@"%d",[annotationView SelectedBox]]];
        //self.view.userInteractionEnabled=YES;
        
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Box not selected"
                                                        message:@"Please, select a box."
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    }
    
    keyboardVisible=NO;
    
}
-(IBAction)doneAction:(id)sender{

    // first box is always a Lenovo, second is always a Macbook, for now
    for (int i=0; i<[dictionaryBox count]; i++) {
        // TODO: add stupid classifier here
        if (i==0)   [self.objectsListViewController addProduct:[Product getLenovoLaptop]];
        else        [self.objectsListViewController addProduct:[Product getMacbookLaptop]];
    }
    
    [self.navigationController pushViewController:self.objectsListViewController animated:YES];
    
}

-(IBAction)deleteAction:(id)sender{
    int num=[dictionaryBox count];
    if((num<1)||([annotationView SelectedBox]==-1)){
        return;
    }
    Box *b;
    
    for (int i=[annotationView SelectedBox]+1; i<num; i++) {
        b=[dictionaryBox objectForKey:[NSString stringWithFormat:@"%d",i]];
        [dictionaryBox setObject:b forKey:[NSString stringWithFormat:@"%d",i-1]];
    }
    [dictionaryBox removeObjectForKey:[NSString stringWithFormat:@"%d",num-1]];
    numLabels--;
    selectedBox=-1;
    [annotationView setSelectedBox:-1];
    [annotationView setNeedsDisplay];
    
    if (numLabels<2){
        self.addButton.enabled = true;
    }
    if (numLabels==0){
        self.deleteButton.enabled = false;

    }
    
}
-(void) dealloc{
    [super dealloc];
    [annotationView dealloc];
}

@end