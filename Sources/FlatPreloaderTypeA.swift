//
//  Loader.swift
//  Test
//
//  Created by Walter Da Col on 01/11/14.
//  Copyright (c) 2014 Walter Da Col. All rights reserved.
//

import UIKit

/**
This preloader is composed by four dots, each one assigned to a quadrants.
The animation is composed by dots changing quadrant in a given order (clockwise by default).
*/
class FlatPreloaderTypeA : FlatPreloader {
    /**
    Enumerator for quadrants.
    
    - UpLeft:    The upper left quadrant.
    - UpRight:   The upper right quadrant.
    - DownRight: The lower right quadrant.
    - DownLeft:  The lower left quadrant.
    */
    private enum QuadrantPosition : UInt {
        case UpLeft = 0, UpRight, DownRight, DownLeft
    }
    
    /// An alias to make "quadrants" management easy.
    private typealias Quadrant = (layer: DotLayer, position: QuadrantPosition)
    
    
    /// Quadrants array.
    private var quadrants : [Quadrant] = [
        (DotLayer(), QuadrantPosition.UpLeft),
        (DotLayer(), QuadrantPosition.UpRight),
        (DotLayer(), QuadrantPosition.DownRight),
        (DotLayer(), QuadrantPosition.DownLeft)
    ]
    
    /// Layer inset construction
    private var insetLayer = CALayer()
    
    /// If preloader is currently animated
    private var animated : Bool = false
    
    /// Dots color (clockwise order).
    var dotColors : (upLeft: UIColor, upRight: UIColor, downRight: UIColor, downLeft: UIColor) {
        get {
            return (
                UIColor(CGColor: self.quadrants[0].layer.fillColor),
                UIColor(CGColor: self.quadrants[1].layer.fillColor),
                UIColor(CGColor: self.quadrants[2].layer.fillColor),
                UIColor(CGColor: self.quadrants[3].layer.fillColor)
            )
        }
        set {
            self.quadrants[0].layer.fillColor = newValue.upLeft.CGColor
            self.quadrants[1].layer.fillColor = newValue.upRight.CGColor
            self.quadrants[2].layer.fillColor = newValue.downRight.CGColor
            self.quadrants[3].layer.fillColor = newValue.downLeft.CGColor
        }
    }
    
    /// A CGFloat value that sets the minimum distance between dots.
    var dotsDistance : CGFloat = 0.0
    
    /// A Boolean value that controls whether the receiver will go clockwise or counterclockwise when the animation is running.
    var reverseAnimation : Bool = false
    
    /// A CFTimeInterval value that sets the duration of an animation cycle
    var animationDuration : CFTimeInterval = 2.52
    
    /// A CGFloat value that sets the dots padding from view borders
    var padding : CGFloat = 0.0
    
    /// A Boolean value that controls the receiver backing layer. If `true` layer.cornerRadius will be resized to (dotRadius + padding)
    var automaticCornerRadius : Bool = false
    
    /**
    Adds layers
    */
    private func addLayers() {
        self.layer.addSublayer(self.insetLayer)
        for quadrant in quadrants {
            self.insetLayer.addSublayer(quadrant.layer)
        }
    }
    
    /**
    Creates a new instance of this loader.
    
    :param: frame                   The loader frame.
    :param: dotsDistance            The minimum distance between dots. Defaults to 0.0.
    :param: dotsColors              The dots colors (a tuple of four colors). Defaults to all black.
    :param: animationDuration       The animation (single complete rotation) duration. Defaults to 2.52.
    :param: reverseAnimation        If true, the animation will go counterclockwise. Defaults to false
    :param: padding                 The dots inset from external frame. Defaults to 0.0.
    :param: hidesWhenStopped        If true, hides the preloader when animation stops. Defaults to true.
    :param: automaticCornerRadius   If true, the backing layer will automatically resize its cornerRadius value. Defaults to false.
    
    :returns: a new instance
    */
    init(
        frame: CGRect,
        dotsDistance: CGFloat = 0.0,
        dotsColors: (UIColor, UIColor, UIColor, UIColor) = (UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor(),UIColor.blackColor()),
        animationDuration: CFTimeInterval = 2.52,
        reverseAnimation: Bool = false,
        padding: CGFloat = 0.0,
        hidesWhenStopped: Bool = true,
        automaticCornerRadius: Bool = false){
        
        super.init(frame: frame)
        
        // Add layers
        self.addLayers()
            
        // Attributes
        self.dotColors = dotsColors
        self.dotsDistance = dotsDistance
        self.reverseAnimation = reverseAnimation
        self.animationDuration = animationDuration
        self.padding = padding
        self.automaticCornerRadius = automaticCornerRadius
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Create a new instance of this loader using a default style.
    
    :param: style The given style.
    
    :returns: A new instance.
    */
    override init(style: Style){
        var frame : CGRect
        var padding : CGFloat
        var distance : CGFloat
        
        let colorA = UIColor(red: 237.0/255.0, green: 177.0/255.0, blue: 111.0/255.0, alpha: 1.0)
        let colorB = UIColor(red: 80.0/255.0, green: 172.0/255.0, blue: 154.0/255.0, alpha: 1.0)
        let colorC = UIColor(red: 210.0/255.0, green: 85.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        let colorD = UIColor(red: 54.0/255.0, green: 77.0/255.0, blue: 88.0/255.0, alpha: 1.0)
        
        switch style {
        case .Small:
            frame = CGRectMake(0,0,32,32)
            padding = 3.0
            distance = 1.0
        case .Medium:
            frame = CGRectMake(0, 0, 64, 64)
            padding = 6.0
            distance = 2.0
        case .Big:
            frame = CGRectMake(0, 0, 128, 128)
            padding = 12.0
            distance = 4.0
        }
        
        super.init(style: style)
        
        // Add layers
        self.addLayers()
        
        // Attributes
        self.dotColors = (colorA, colorB, colorC, colorD)
        self.dotsDistance = distance
        self.padding = padding
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Resize instet layer
        self.insetLayer.frame = CGRectInset(self.layer.bounds, self.padding, self.padding)
        
        // Resize and align dot layers
        let size = quadrantSize()
        for quadrant in quadrants {
            var origin = quadrantOrigin(quadrant.position)
            quadrant.layer.frame = CGRect(origin: quadrantOrigin(quadrant.position), size: size)
            quadrant.layer.draw() // redraw ovals
        }
        
        if self.automaticCornerRadius {
            self.layer.cornerRadius = CGFloat(dotRadius()) + self.padding
        }
    }
    
    override func startAnimating() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        for quadrant in self.quadrants {
            if quadrant.layer.isPaused() {
                quadrant.layer.resume()
            } else {
                quadrant.layer.addAnimation(quadrantAnimation(quadrant), forKey: "dotAnimation")
            }
        }
        CATransaction.commit()
    }

    override func stopAnimating() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        for quadrant in self.quadrants {
            quadrant.layer.pause()
        }
        
        CATransaction.commit()
        if self.hidesWhenStopped {
            self.hidden = true
        }
    }

    override func isAnimating() -> Bool {
        return self.animated
    }
    
    /**
    Returns a complete keyframe animation for one quadrant.
    
    
    :param: quadrant The quadrant to animate.
    
    :returns: A quadrant animation.
    */
    private func quadrantAnimation(quadrant : Quadrant) -> CAKeyframeAnimation {

        var currentPoint = quadrantPosition(quadrant.position)
        var currentQuadrant = quadrant.position
        var functions : [CAMediaTimingFunction] = [] // For assigning a function to every keyframe animation
        
        var path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, currentPoint.x, currentPoint.y)
        
        // Add all corners (or quadrant positions)
        for _ in 1...4 {
            currentQuadrant = nextQuadrant(currentQuadrant)
            currentPoint = quadrantPosition(currentQuadrant)
            CGPathAddLineToPoint(path, nil, currentPoint.x, currentPoint.y)
            functions.append(CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault))
        }

        var animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path
        animation.duration = self.animationDuration
        animation.timingFunctions = functions
        animation.repeatCount = Float(CGFloat.max)
    
        return animation
    }
    
    /**
    Returns the max dot radius for current combination of padding and dotsDistance. This number will be alway rounded to its floor value.
    
    :returns: The dots radius.
    */
    private func dotRadius() -> UInt{
        let smallestSide = max(0, Float(min(self.insetLayer.bounds.size.height, self.insetLayer.bounds.size.width)) - Float(dotsDistance))
        let triangleSide = Float(smallestSide) * sqrt(2.0) * 0.5
        let semiperimeter = (triangleSide * 2.0 + smallestSide) * 0.5
        if semiperimeter == 0 {
            return 0
        }
        let triangleArea = (smallestSide * (smallestSide * 0.5)) * 0.5
        let radius = triangleArea / semiperimeter
        return UInt(floor(radius))
    }
    
    /**
    Returns the next quadrant position with current animation order (see reverse attribute).
    
    :param: quadrant The given quadrant.
    
    :returns: The next quadrant position.
    */
    private func nextQuadrant(quadrant: QuadrantPosition) -> QuadrantPosition {
        if (reverseAnimation) {
            return QuadrantPosition(rawValue: (quadrant.rawValue == 0 ? 3 : quadrant.rawValue - 1))!
        } else {
            return QuadrantPosition(rawValue: (quadrant.rawValue + 1) % 4)!
        }
        
    }
    
    /**
    Returns the max quadrant size for current combination of padding and dotsDistance.
    
    :returns: The quadrant size.
    */
    private func quadrantSize() -> CGSize {
        let radius = CGFloat(dotRadius())
        return CGSize(width: radius * 2.0, height: radius * 2.0)
        
    }
    
    /**
    Returns the origin of the given quadrant from its current quadrantPosition (animation do not change quadrantPosition, so it's the starting origin).
    
    :param: quadrant The given quadrant.
    
    :returns: The quadrant origin.
    */
    private func quadrantOrigin(quadrant: QuadrantPosition) -> CGPoint{
        let radius = CGFloat(dotRadius())
        switch quadrant {
        case .UpLeft:
            return CGPoint(x: 0.0, y: 0.0)
        case .UpRight:
            return CGPoint(x: (self.insetLayer.bounds.width - radius * 2.0), y: 0)
        case .DownRight:
            return CGPoint(x: (self.insetLayer.bounds.width - radius * 2.0), y: (self.insetLayer.bounds.height - radius * 2.0))
        case .DownLeft:
            return CGPoint(x: 0, y: (self.insetLayer.bounds.height - radius * 2.0))
        }
        
    }
    
    /**
    Returns the position (anchor point 0.5, 0.5) of the given quadrant from its current quadrantPosition (animation do not change quadrantPosition, so it's the starting position).
    
    :param: quadrant The given quadrant.
    
    :returns: The quadrant position.
    */
    private func quadrantPosition(quadrant: QuadrantPosition) -> CGPoint {
        let radius = CGFloat(dotRadius())
        let origin = quadrantOrigin(quadrant)
        
        return CGPoint(x: origin.x + radius, y: origin.y + radius)
    }
    
}