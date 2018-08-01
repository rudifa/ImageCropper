//
//  CGUtil.swift v.0.1.0
//  Swift4Util
//
//  Created by Rudolf Farkas on 31.07.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import UIKit

// Formatting

extension CGFloat {
    var fmt: String { return String(format: "%.3g", self) }
}

extension CGPoint {
    var fmt: String { return String(format: "(%.2f, %.2f)", self.x, self.y) }
}

extension CGSize {
    var fmt: String { return String(format: "(%.2f, %.2f)", self.width, self.height) }
}

extension CGRect {
    var fmt: String { return "\(origin.fmt),\(size.fmt)" }
}

// Arithmetic operations

extension CGSize {

    static func * (size: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width * scalar, height: size.height * scalar)
    }

    static func * (size: CGSize, scalar: Double) -> CGSize {
        return size * CGFloat(scalar)
    }

    static func / (size: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: size.width / scalar, height: size.height / scalar)
    }

    static func / (size: CGSize, scalar: Double) -> CGSize {
        return size / CGFloat(scalar)
    }
}

