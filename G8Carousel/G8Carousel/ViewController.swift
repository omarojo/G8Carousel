//
//  ViewController.swift
//  G8Carousel
//
//  Created by Omar Juarez Ortiz on 2017-05-12.
//  Copyright © 2017 Omar Juarez Ortiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var g8Car: G8Carousel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        g8Car = G8Carousel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 150))
        
        let filterItems = [G8CarouselItem(),G8CarouselItem(),G8CarouselItem(),G8CarouselItem(),G8CarouselItem(),G8CarouselItem(),G8CarouselItem(),G8CarouselItem(),G8CarouselItem(),G8CarouselItem(),G8CarouselItem()]
        g8Car.allItems = filterItems
        
        self.view.addSubview(g8Car)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

