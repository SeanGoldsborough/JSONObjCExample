//
//  ViewController.m
//  JSONObjCExample
//
//  Created by Sean Goldsborough on 8/21/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

#import "ViewController.h"
#import "Course.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray<Course *> *courses;

@end

@implementation ViewController

NSString *cellID = @"cellID";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCourses];
    [self fetchCoursesUsingJSON];
    self.navigationItem.title = @"Courses";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellID];
 
}

-(void)setupCourses{
   self.courses = NSMutableArray.new;
    Course *course = Course.new;
    course.name = @"Instagram Firebase";
    course.numberOfLessons = @(49);
    [self.courses addObject:course];
}

-(void)fetchCoursesUsingJSON{
    //https://api.letsbuildthatapp.com/jsondecodable/courses
    NSString *urlString = @"https://api.letsbuildthatapp.com/jsondecodable/courses";
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"finished fetching courses");
        
        //USE TO PRINT JSON DATA TO CONSOLE FOR FURTHER ANALYSIS ON HOW TO PARSE PROPERLY
        
        NSString *dummyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
       // NSLog(@"Dummy data is: %@   ", dummyData);
        
        NSError *myError;
        NSArray *coursesJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&myError];
        
        if (myError){
            NSLog(@"failed to parse JSON: %@", myError);
            return;
        }
        
        NSMutableArray<Course *> *courses = NSMutableArray.new;
        for (NSDictionary *courseDict in coursesJSON){
            NSString *name = courseDict[@"name"];
            NSNumber *numberOfLessons = courseDict[@"number_of_lessons"];
            Course *course = Course.new;
            course.name = name;
            course.numberOfLessons = numberOfLessons;
            [courses addObject:course];
            
           
        }
        
         NSLog(@"courses array is %@", courses);
        self.courses = courses;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
       
        
    }]resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    cell.backgroundColor = UIColor.redColor;
    
    Course *course = self.courses[indexPath.row];
    
    cell.textLabel.text = course.name;
    cell.detailTextLabel.text = course.numberOfLessons.stringValue;
    
    return cell;
}



@end
