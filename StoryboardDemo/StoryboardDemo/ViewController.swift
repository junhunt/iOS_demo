//
//  ViewController.swift
//  StoryboardDemo
//
//  Created by Jun on 23/10/2017.
//  Copyright © 2017 Guangzhou juku software technology co.,LTD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "HOME"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressMeButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "presentSegueId", sender: "i am sender!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentSegueId" {
            if let destinationNC = segue.destination as? UINavigationController {
                if let destinationVC = destinationNC.visibleViewController as? ThirdViewController {
                    destinationVC.passValue = "雅尼"
                }
            }
        }
        
        if let destinationVC = segue.destination as? SecondViewController {
            destinationVC.passValue = "1234567"
        }
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    
    }
}

