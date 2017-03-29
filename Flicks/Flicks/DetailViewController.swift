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
    
    
    public var imagePath : String = "";
    public var text : String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set content size on the scroll view
        let contentWidth = scrollView.bounds.width
        var contentHeight = scrollView.bounds.height * 1.2
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight);
        
        // set the scrollable view
        let grayView = UIView(frame: CGRect(x: 50, y: 300, width: scrollView.contentSize.width - 100, height: 350));
        grayView.backgroundColor = UIColor.black;
        grayView.alpha = 0.6;
        scrollView.addSubview(grayView)
        scrollView.showsVerticalScrollIndicator = false;
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: scrollView.contentSize.width - 100, height: 350));
      //  label.numberOfLines = 15;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping;
        label.text = text;

        let myString: NSString = text as NSString
        let expectedLabelSize: CGSize = myString.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)]);
        
        //adjust the label the the new height.
        var newFrame = label.frame;
        newFrame.size.height = expectedLabelSize.height;
        label.frame = newFrame;
        
        label.textColor = UIColor.white;
        
      //  grayView.frame = CGRect(x: 50, y: 300, width: label.frame.width, height: label.frame.height);
        
        grayView.addSubview(label);
        // scrollView.addSubview(label);


        // set to new content height based on label height
        contentHeight = grayView.frame.height + scrollView.bounds.height - 300;
      //  scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight);
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
