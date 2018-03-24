//
//  http://www.raywenderlich.com/84434/sprite-kit-swift-tutorial-beginners
//

import Foundation
import UIKit

let LARGE:CGFloat = 1000.0

// Make + the vector addition

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

// When the player touches on a point, we compute a line from the sprite going
// through the point and CONTINUES to the boundary of the screen. This function
// returns the point on the beyond the boundary of the screen
//  para:
//          startPoint: the position of the sprite
//          endPoint: the position of the point on the desired line, beyond the screen
//  We expect a bullet to be shot from startPoint to endPoint
func realDestination(_ startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
    let offset = endPoint - startPoint
    let direction = offset.normalized()
    let shootAmount = direction * LARGE // make sure the destination is out of the screen
    return shootAmount + startPoint
    
} // realDestination

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

