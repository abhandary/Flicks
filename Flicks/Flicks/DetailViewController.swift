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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set content size on the scroll view
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 1.2
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight);
        
        //
        let grayView = UIView(frame: CGRect(x: 50, y: 300, width: scrollView.contentSize.width - 100, height: 150));
        grayView.backgroundColor = UIColor.black;
        grayView.alpha = 0.6;
        scrollView.addSubview(grayView)
        scrollView.showsVerticalScrollIndicator = false;
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
