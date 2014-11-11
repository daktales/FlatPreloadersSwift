//
//  FlatPreloader.swift
//  Test
//
//  Created by Walter Da Col on 10/11/14.
//  Copyright (c) 2014 Walter Da Col. All rights reserved.
//

import UIKit

/**
The WDPausable protocol allows to pause/resume animations.
*/
protocol WDPausable {
    /**
    Returns whether the receiver is paused.
    
    :returns: `true` if the receiver is paused, otherwise `false`.
    */
    func isPaused() -> Bool
    /**
    Pauses the animations of the receiver.
    */
    func pause()
    /**
    Resumes the animations of the receiver.
    */
    func resume()
}

extension CALayer : WDPausable {
    func isPaused() -> Bool {
        return self.speed == 0.0
    }

    func pause() {
        if isPaused() { return }
        
        let pausedTime = self.convertTime(CACurrentMediaTime(), fromLayer: nil)
        self.speed = 0.0;
        self.timeOffset = pausedTime;
    }
    
    func resume() {
        if !isPaused() { return }
        
        let pausedTime = self.timeOffset
        
        self.speed = 1.0;
        self.timeOffset = 0.0;
        self.beginTime = 0.0;
        let timeSincePause = self.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        
        self.beginTime = timeSincePause;
    }
}

/**
Basic CAShapeLayer class with an inscribed oval.
*/
class DotLayer : CAShapeLayer {
    
    override init!() { super.init() }
    
    override init!(layer: AnyObject!) { super.init(layer: layer) }
    
    required init(coder: NSCoder) { fatalError("NSCoding not supported") }
    
    func draw() {
        self.path = UIBezierPath(ovalInRect: self.bounds).CGPath
    }
}

class FlatPreloader : UIView {
    /**
    FlatPreloader Style
    
    - Small:  The small one (32pt)
    - Medium: The medium one (64pt)
    - Big:    The big one (128pt)
    */
    enum Style {
        case Small
        case Medium
        case Big
    }
    
    /// A Boolean value that controls whether the receiver is hidden when the animation is stopped.
    var hidesWhenStopped : Bool = true
    
    /**
    Starts the animation of the preloader.
    
    When the progress indicator is animated, the dots spins to indicate indeterminate progress.
    The indicator is animated until `stopAnimating` is called.
    */
    func startAnimating() {}
    
    /**
    Stops the animation of the progress indicator.
    
    Call this method to stop the animation of the progress indicator started with a call to `startAnimating`.
    When animating is stopped, the indicator is hidden, unless `hidesWhenStopped` is `false`.
    */
    func stopAnimating() {}
    
    /**
    Returns whether the receiver is animating.
    
    :returns: `true` if the receiver is animating, otherwise `false`.
    */
    func isAnimating() -> Bool { return false }
    
    /**
    Basic init
    
    :param: frame            The loader frame.
    
    :returns: a new instance.
    */
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    /**
    Create a new instance of this loader using a default style.
    
    :param: style The given style.
    
    :returns: A new instance.
    */
    init(style: FlatPreloader.Style){
        var frame : CGRect
        switch style {
        case .Small:
            frame = CGRectMake(0,0,32,32)
        case .Medium:
            frame = CGRectMake(0, 0, 64, 64)
        case .Big:
            frame = CGRectMake(0, 0, 128, 128)
        }
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}