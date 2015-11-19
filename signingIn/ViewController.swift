//
//  ViewController.swift
//  signingIn
//
//  Created by Gary J on 14/07/2015.
//  Copyright (c) 2015 fromTheLoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var joinNow: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingPulseContainer: UIView!
    @IBOutlet weak var pulseBig: UIView!
    @IBOutlet weak var resetDidPress: UIButton!
    @IBOutlet weak var pulseMed: UIView!
    @IBOutlet weak var pulseSmall: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var joinUp: UIButton!
    @IBOutlet weak var formContainer: UIView!
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tickCircleBg: UIView!
    @IBOutlet weak var succesTickWhite: UIImageView!
    @IBOutlet weak var avatarTopConstraint: NSLayoutConstraint!
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //  VARIABLES
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // Colors
    var pulseNav100 = UIColor(red: 33/255, green: 192/255, blue: 100/255, alpha: 1)
    var pulseNav75 = UIColor(red: 33/255, green: 192/255, blue: 100/255, alpha: 0.75)
    var pulseNav50 = UIColor(red: 33/255, green: 192/255, blue: 100/255, alpha: 0.5)
    var pulseNav25 = UIColor(red: 33/255, green: 192/255, blue: 100/255, alpha: 0.25)
    
    // Index count
    var fakeCount = 0
    
    // Durations
    let durationOut = 0.350
    let durationIn = 0.250
    let shakeDuration = 0.060
    
   
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Login Success & Tick animation then prepare for animation
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func successTickReset(){
        tickCircleBg.hidden = true
        succesTickWhite.hidden = true
        tickCircleBg.alpha = 0
        succesTickWhite.alpha = 0
        tickCircleBg.transform = CGAffineTransformMakeScale(2.5, 2.5)
        succesTickWhite.transform = CGAffineTransformMakeScale(2.5, 2.5)
    }
    
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ANIMATE SUCCESS TICK
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    //  Success tick animate
    func animateSuccessTick(){
        tickCircleBg.hidden = false
        succesTickWhite.hidden = false
        self.retractPulseRings()
        
        //Circle BG
        UIView.animateWithDuration(0.8, delay: 0.070, usingSpringWithDamping: 0.800, initialSpringVelocity: 10.0, options: [], animations: {
            self.tickCircleBg.alpha = 1
            self.succesTickWhite.alpha = 1
            self.tickCircleBg.transform = CGAffineTransformMakeScale(1.0, 1.0)
            },  completion:nil)
        
        //Tick
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.700, initialSpringVelocity: 14.0, options: [], animations: {
            self.succesTickWhite.alpha = 1
            self.succesTickWhite.transform = CGAffineTransformMakeScale(1.0, 1.0)
            },  completion:{finished in
                
                UIView.animateWithDuration(self.durationIn, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
                    self.loadingPulseContainer.hidden = true
                    self.dismissVC()
                    },  completion:{finished in
                        
                        UIView.animateWithDuration(0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
                            self.dismissVC()
                            }, completion:{finished in
                                self.showResetButton()
                        })
                })
        })
    }
    

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Centering the avatar in the container
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func centerInView(){
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.850, initialSpringVelocity: 15.0, options: [], animations: {
            
            self.loadingPulseContainer.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)
            
            },  completion:nil)
    }
    

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Setup Reset button
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func setupResetButton(){
        resetDidPress.hidden = true
        self.resetDidPress.transform = CGAffineTransformMakeTranslation(0, -40)
    }
    
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Show Reset button
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func showResetButton(){
        resetDidPress.hidden = false
        
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.850, initialSpringVelocity: 15.0, options: [], animations: {
            self.resetDidPress.transform = CGAffineTransformMakeTranslation(0, 0)
            },  completion:nil)
    }
    
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Re-apply viewdidload constant 50 from the top
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func returnToOrigin() {
        
        self.avatarTopConstraint.constant = 11
        
        UIView.animateWithDuration(0.4, delay: 0.060, usingSpringWithDamping: 0.550, initialSpringVelocity: 4.0, options: [], animations: {
            self.view.layoutIfNeeded()
            },  completion: {finished in
                
                UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.550, initialSpringVelocity: 1.0, options: [], animations: {
                    self.avatarTopConstraint.constant = 10
                    },  completion:{ _ in
                            self.loadingPulseContainer.hidden = false
                    }
                )
        })
    }
    
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Reset to Origin
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func resetToOrigin() {
        self.avatarTopConstraint.constant = 11
        self.avatarTopConstraint.constant = 10
        self.loadingPulseContainer.hidden = false
    }

    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Hide Keyboard if touched outside
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Resign one textfield and move onto the next textfield - needs further conditions
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if passwordTextField.text!.isEmpty {
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else {
            checkingLoginDetails()
            passwordTextField.resignFirstResponder()
        }
        return true;
    }
    
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Fade in blur view
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func fadeInBlur() {
        blurBackground.hidden = false
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.blurBackground.alpha = 1
            },  completion:nil)
    }

    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Fade out blur view
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func fadeOutBlur() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.blurBackground.alpha = 0
            },  completion:{finish in
                
                UIView.animateWithDuration(self.durationIn, delay: 0.5, usingSpringWithDamping: 0.550, initialSpringVelocity: 1.0, options: [], animations: {
                    self.blurBackground.hidden = false
                    },  completion:nil)
        })
    }
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Reset count var
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func resetFakeCount() {
        self.fakeCount = 0
    }

    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Retract green pulse rings
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func retractPulseRings() {
        
        resetFakeCount()
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.pulseSmall.transform = CGAffineTransformMakeScale(0.8, 0.8)
            self.pulseMed.transform = CGAffineTransformMakeScale(0.7, 0.7)
            self.pulseBig.transform = CGAffineTransformMakeScale(0.6, 0.6)
            },  completion: {finished in
                self.pulseSmall.hidden = true
                self.pulseMed.hidden = true
                self.pulseBig.hidden = true
        })
    }
    
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Hide green pulse rings & reset count var
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

    func hidePulseRings() {
        resetFakeCount()
        self.pulseSmall.transform = CGAffineTransformMakeScale(0.8, 0.8)
        self.pulseMed.transform = CGAffineTransformMakeScale(0.7, 0.7)
        self.pulseBig.transform = CGAffineTransformMakeScale(0.6, 0.6)
        self.pulseSmall.hidden = true
        self.pulseMed.hidden = true
        self.pulseBig.hidden = true
    }

    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Dismiss VC & Keyboard if active
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func dismissVC(){
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.view.endEditing(true)
    }

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Login - pulse animation with password and username check
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func checkingLoginDetails() {
        
        self.fadeInBlur()
        self.centerInView()
        self.pulseSmall.hidden = false
        self.pulseMed.hidden = false
        self.pulseBig.hidden = false
        
        UIView.animateWithDuration(self.durationOut, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.pulseSmall.transform = CGAffineTransformMakeScale(1.1, 1.1)
            
            }, completion: {finished in
                
                UIView.animateWithDuration(self.durationIn, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
                    self.pulseSmall.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                    },  completion:nil)
        })
        
        UIView.animateWithDuration(self.durationOut, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.pulseMed.transform = CGAffineTransformMakeScale(1.1, 1.1)
            
            }, completion: {finished in
                
                UIView.animateWithDuration(self.durationIn, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
                    self.pulseMed.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                    },  completion:nil)
        })
        
        UIView.animateWithDuration(self.durationOut, delay: 0.2, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.pulseBig.transform = CGAffineTransformMakeScale(1.1, 1.1)
            
            }, completion: {finished in
                
                UIView.animateWithDuration(self.durationIn, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
                    self.pulseBig.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                    },  completion: {finished in
                        
                        //~~ Add 1 ~~
                        self.fakeCount = self.fakeCount + 1
                        //~~ If Statement ~~
                        if self.fakeCount == 4 {
                            
                            //~~ If username & Password are correct De-animate and unwind segue ~~
                            if self.passwordTextField.text!.isEmpty || self.usernameTextField.text!.isEmpty{
                                self.loginFailed()
                                
                            } else {
                                self.animateSuccessTick()
                            }
                        } else {
                            self.checkingLoginDetails()
                        }
                })
        })
    }
    
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Login failed - shake animation & reset fake count
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

    func loginFailed() {
        
        resetFakeCount()
        hidePulseRings()
        
        
        UIView.animateWithDuration(self.shakeDuration, delay: 0.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 1.0, options: [], animations: {
            self.avatar.transform = CGAffineTransformMakeTranslation(18.0, 0.0)
            },  completion:{ finished in
                
                UIView.animateWithDuration(self.shakeDuration, delay: 0.0, usingSpringWithDamping: 10.0, initialSpringVelocity: 1.0, options: [], animations: {
                    self.avatar.transform = CGAffineTransformMakeTranslation(-18.0, 0.0)
                    },  completion:{ finished in
                        
                        UIView.animateWithDuration(self.shakeDuration, delay: 0.0, usingSpringWithDamping: 15.0, initialSpringVelocity: 1.0, options: [], animations: {
                            self.avatar.transform = CGAffineTransformMakeTranslation(12.0, 0.0)
                            },  completion:{ finished in
                                
                                UIView.animateWithDuration(self.shakeDuration, delay: 0.0, usingSpringWithDamping: 20.0, initialSpringVelocity: 1.0, options: [], animations: {
                                    self.avatar.transform = CGAffineTransformMakeTranslation(-12.0, 0.0)
                                    },  completion:{ finished in
                                        
                                        UIView.animateWithDuration(self.shakeDuration, delay: 0.0, usingSpringWithDamping: 25.0, initialSpringVelocity: 1.0, options: [], animations: {
                                            self.avatar.transform = CGAffineTransformMakeTranslation(6.0, 0.0)
                                            },  completion:{ finished in
                                                
                                                UIView.animateWithDuration(self.shakeDuration, delay: 0.0, usingSpringWithDamping: 30.0, initialSpringVelocity: 1.0, options: [], animations: {
                                                    self.avatar.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
                                                    },  completion:{ finished in
                                                        
                                                        self.returnToOrigin()
                                                        self.fadeOutBlur()
                                                        
                                                })
                                        })
                                })
                        })
                })
        })
    }
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Setup TheCorner Radius on UIViews
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func setUpCornerRadius(){
        tickCircleBg.layer.cornerRadius = 60
        joinNow.layer.cornerRadius = 4
        pulseBig.layer.cornerRadius = 75
        pulseMed.layer.cornerRadius = 67.5
        pulseSmall.layer.cornerRadius = 60
        resetDidPress.layer.cornerRadius = 4
    }
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Setup the loading pulse
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func setUpTheLoadingPulse(){
        pulseSmall.hidden = true
        pulseMed.hidden = true
        pulseBig.hidden = true
        pulseSmall.transform = CGAffineTransformMakeScale(0.8, 0.8)
        pulseMed.transform = CGAffineTransformMakeScale(0.7, 0.7)
        pulseBig.transform = CGAffineTransformMakeScale(0.6, 0.6)
    }
    
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Setup the blur function
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func setUpTheBlurFunction(){
        blurBackground.hidden = true
        blurBackground.alpha = 0
    }
    
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Setup the pulse Colors
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    func assignPulseColors(){
        tickCircleBg.backgroundColor = pulseNav100
        pulseSmall.backgroundColor = pulseNav75
        pulseMed.backgroundColor = pulseNav50
        pulseBig.backgroundColor = pulseNav25
    }
    

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Sign In Button
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    @IBAction func signInButtonDidPress(sender: AnyObject) {
        checkingLoginDetails()
    }

    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Reset Button Pressed
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    @IBAction func resetButtonDidPress(sender: AnyObject) {
        setUpTheLoadingPulse()
        setUpTheBlurFunction()
        setupResetButton()
        successTickReset()
        hidePulseRings()
        assignPulseColors()
        resetToOrigin()
        passwordTextField.text = nil
        usernameTextField.text = nil

    }
    
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    View did load
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Delegate text fields
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        setUpCornerRadius()
        setUpTheLoadingPulse()
        setUpTheBlurFunction()
        setupResetButton()
        assignPulseColors()
        successTickReset()
    }
    
}











