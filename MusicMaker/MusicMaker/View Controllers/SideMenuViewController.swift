//
//  SideMenuViewController.swift
//  MusicMaker
//
//  Created by Vuk Radosavljevic on 11/14/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        menuImageView.image = UIImage(named: "SideMenu")
        setupSideMenuToBeOffScreen()
    }
    
    // MARK: - Private Methods
    //Moves the buttoms and the imageview off screen so when the menu shows it can animate it on screen
    private func setupSideMenuToBeOffScreen() {
        menuImageView.transform = CGAffineTransform(translationX: -self.menuImageView.frame.width, y: 0)
        self.button1.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        self.button2.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        self.button3.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        self.button4.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        self.button5.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
    }
    
    
    func animateHidingOfMenu() {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.button1.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            self.button5.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.button2.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            self.button4.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        })
        
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseIn, animations: {
            self.menuImageView.transform = CGAffineTransform(translationX: -self.menuImageView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseIn, animations: {
            self.button3.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        })
    }
    
    func animateShowingOfMenu() {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.menuImageView.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.button3.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.button2.transform = .identity
            self.button4.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.button1.transform = .identity
            self.button5.transform = .identity
        })
    }
}