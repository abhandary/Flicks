//
//  TabBarViewController.swift
//  Flicks
//
//  Created by Akshay Bhandary on 3/28/17.
//  Copyright © 2017 AkshayBhandary. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nowPlayingVC = self.storyboard?.instantiateViewController(withIdentifier: "NavController");
        nowPlayingVC?.title = "Now Playing";
        nowPlayingVC?.tabBarItem.image =  UIImage(named: "movie", in: Bundle(for: type(of: self)), compatibleWith: nil);
        
        let topRatedVC = self.storyboard?.instantiateViewController(withIdentifier: "NavController");
        topRatedVC?.title = "Top Rated";
        topRatedVC?.tabBarItem.image = UIImage(named: "star", in: Bundle(for: type(of: self)), compatibleWith: nil);
        
        self.viewControllers = [nowPlayingVC!, topRatedVC!];
        
        // Do any additional setup after loading the view.
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
