//
//  EitherSpec.swift
//  Swiftx
//
//  Created by Robert Widmann on 7/16/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

import Swiftx
import XCTest
import SwiftCheck

extension Either where L : Arbitrary, R : Arbitrary {
	static var arbitrary : Gen<Either<L, R>> {
		return Gen.oneOf([
			Either.Left <^> L.arbitrary,
			Either.Right <^> R.arbitrary,
		])
	}

	static func shrink(e : Either<L, R>) -> [Either<L, R>] {
		switch e {
		case .Left(let x):
			return L.shrink(x).map(Either.Left)
		case .Right(let x):
			return R.shrink(x).map(Either.Right)
		}
	}
}

// Heterogenous equality
public func == <L : Equatable, R, S>(lhs : Either<L, R>, rhs : Either<L, S>) -> Bool {
	switch (lhs, rhs) {
	case let (.Left(l), .Left(r)) where l == r:
		return true
	default:
		return false
	}
}

public func == <L, R : Equatable, S>(lhs : Either<L, R>, rhs : Either<S, R>) -> Bool {
	switch (lhs, rhs) {
	case let (.Right(l), .Right(r)) where l == r:
		return true
	default:
		return false
	}
}

class EitherSpec : XCTestCase {
	func testProperties() {
		property("isLeft behaves") <- forAllShrink(Either<Int, Int>.arbitrary, shrinker: Either.shrink) { e in
			return e.isLeft == e.fold(true, f: const(false))
		}

		property("isRight behaves") <- forAllShrink(Either<Int, Int>.arbitrary, shrinker: Either.shrink) { e in
			return e.isRight == e.fold(false, f: const(true))
		}
		
		property("left and right behave") <- forAllShrink(Either<Int, Int>.arbitrary, shrinker: Either.shrink) { e in
			return (e.isLeft && e.left != nil) || (e.isRight && e.right != nil)
		}

		property("either is equivalent to explicit case analysis") <- forAllShrink(Either<Int, Int>.arbitrary, shrinker: Either.shrink) { e in
			return forAll { (f : ArrowOf<Int, String>) in
				let s : String
				switch e {
				case .Left(let x):
					s = f.getArrow(x)
				case .Right(let x):
					s = f.getArrow(x)
				}
				return e.either(onLeft: f.getArrow, onRight: f.getArrow) == s
			}
		}

		property("flatMap preserves .Left") <- forAllShrink(Either<String, Int>.arbitrary, shrinker: Either.shrink) { e in
			return forAll { (f : ArrowOf<Int, UInt>) in
				switch e {
				case .Left(_):
					return e.flatMap(Either<String, UInt>.Right • f.getArrow) == e
				case .Right(_):
					return Discard()
				}
			}
		}
	}
}
