//
//  DetailViewController.swift
//  Flicks
//
//  Created by Akshay Bhandary on 3/28/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    let monthMap = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    public var imagePath : String = "";
    public var text : String = "";
    public var movieTitle : String = ""
    public var releaseDate : String = ""
    public var voteAverage : Double = 0.0
    public var backdropImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set content size on the scroll view
        let contentWidth = scrollView.bounds.width
        var contentHeight = scrollView.bounds.height * 1.2
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight);
        
        // set the scrollable view
        let grayView = UIView(frame: CGRect(x: 50, y: 300, width: scrollView.contentSize.width - 100, height: 350));
        grayView.backgroundColor = UIColor.black;
        grayView.alpha = 0.8;
        scrollView.addSubview(grayView)
        scrollView.showsVerticalScrollIndicator = false;
        
        // format the date
        let dateParts = releaseDate.components(separatedBy: "-");
        let month = Int(dateParts[1])
        var dateString = "";
        if let month = month {
            dateString = "\(monthMap[month - 1]) \(dateParts[2]), \(dateParts[0])"
        }
        
        let voteAvgInt = Int(self.voteAverage * 10);
        let label = UILabel(frame: CGRect(x: 5, y: 10, width: scrollView.contentSize.width - 100, height: 350));
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping;
        label.text = "\(movieTitle)\n\n\(dateString)\n👑  \(voteAvgInt)%\n\n\(text)" ;
        label.font = UIFont(name: "Arial-BoldMT", size: 16);

        //adjust the label the the new height.
        label.textColor = UIColor.white;
        label.sizeToFit();
        
        // adjust the gray view's frame per the label's adjusted frame
        grayView.frame = CGRect(x: (UIScreen.main.bounds.width - label.frame.width) / 2, y:scrollView.bounds.height - label.frame.height, width: label.frame.width + 10, height: label.frame.height + 20);
        grayView.addSubview(label);
        
        // set to new content height based on label height
        contentHeight = grayView.frame.height + scrollView.bounds.height - 300;
        
        // set image view to low res image until high res loads
        self.imageView.image = self.backdropImage;
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.imageView.setImageWith(URL(string: imagePath)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
