//
//  SecondViewController.swift
//  StoryboardDemo
//
//  Created by Jun on 23/10/2017.
//  Copyright © 2017 Guangzhou juku software technology co.,LTD. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var passValue: String?
    
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "second vc"
        if let value = passValue {
            displayLabel.text = value
        }
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
