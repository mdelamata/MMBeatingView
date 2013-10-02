//
//  ViewController.m
//  MMBeatingView Demo
//
//  Created by uSpeak on 09/08/13.
//  Copyright (c) 2013 mms. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
-(void)configureView;
-(void)changeSource;

@property (nonatomic, strong) NSMutableArray *sourceArray;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Privated Methods

-(void)configureView{
    
    //fills the source array
    self.sourceArray = [[NSMutableArray alloc] init];
    [self.sourceArray addObjectsFromArray:[NSArray arrayWithObjects:@"GitHub",@"iOS",@"Python",@"Objective-C", nil]];

    //starts beating
    [self.beatingView setFillColor:[UIColor redColor]];
    [self.beatingView startAnimating];
    
    //calls the test method
    [self performSelector:@selector(changeSource) withObject:self afterDelay:4];
}

//this is a test of changing source on the go
-(void)changeSource{
    self.sourceArray = [[NSMutableArray alloc] init];
    [self.sourceArray addObjectsFromArray:[NSArray arrayWithObjects:@"The",@"source",@"has",@"changed!!!", nil]];
    [self.beatingView reloadData];
}

#pragma mark - MMBeatingViewDelegate Methods

-(void)didTouchOptionWithString:(NSString *)string forBeatingView:(MMBeatingView *)beatingView{
    NSLog(@">> beatingView was touched with String %@",string);
    [self.selectionLabel setText:string];
}

#pragma mark - MMBeatingViewDelegateDataSource Methods

-(NSArray *)stringsSourceForBeatingView:(MMBeatingView *)wordSearchPuzzle{
    return self.sourceArray;
}

@end
