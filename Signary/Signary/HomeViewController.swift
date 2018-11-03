//
//  HomeViewController.swift
//  Signary
//
//  Created by Abhinav Tirath on 11/3/18.
//  Copyright © 2018 Abhinav Tirath. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var modeSelected = 0

    @IBAction func gameSelected(_ sender: UIButton) {
        modeSelected = 1
        print("yay")
        //self.performSegue(withIdentifier: "toCamera", sender: self)
    }
    @IBAction func instrumentSelected(_ sender: UIButton) {
        modeSelected = 2
        print("yay")
        //self.performSegue(withIdentifier: "toCamera", sender: self)
    }
    @IBAction func textSelected(_ sender: UIButton) {
        modeSelected = 3
        print("yay")
        //self.performSegue(withIdentifier: "toCamera", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! CameraViewController
        secondViewController.modeSelected = modeSelected
    }

}

