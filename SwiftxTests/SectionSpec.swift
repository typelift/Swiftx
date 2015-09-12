//
//  SectionTests.swift
//  Swiftx
//
//  Created by Robert Widmann on 11/24/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import XCTest
import Swiftx
import SwiftCheck

class SectionTests: XCTestCase {
	func testBitShiftProperties() {
		property("") <- forAll { (x : ArrayOf<Positive<Int>>, sh : Positive<Int>) in
#if arch(i386) || arch(arm)
			let xs = x.getArray.map { min(31, $0.getPositive) }
			let shft = min(31, sh.getPositive)
#else
			let xs = x.getArray.map { min(63, $0.getPositive) }
			let shft = min(63, sh.getPositive)
#endif
			return
				xs.map(>>shft) == xs.map { x in x >> shft }
				^&&^
				xs.map(shft>>) == xs.map { x in shft >> x }
		}

		property("") <- forAll { (x : ArrayOf<Positive<Int>>, sh : Positive<Int>) in
#if arch(i386) || arch(arm)
			let xs = x.getArray.map { min(31, $0.getPositive) }
			let shft = min(31, sh.getPositive)
#else
			let xs = x.getArray.map { min(63, $0.getPositive) }
			let shft = min(63, sh.getPositive)
#endif
			return
				xs.map(<<shft) == xs.map { x in x << shft }
				^&&^
				xs.map(shft<<) == xs.map { x in shft << x }
		}
	}

	func testArithmeticSections() {
		property("") <- forAll { (x : ArrayOf<Int>, i : Int) in
			let xs = x.getArray
			return
				xs.map(+i) == xs.map { $0 + i }
				^&&^
				xs.map(i+) == xs.map { i + $0 }
		}

		property("") <- forAll { (x : ArrayOf<NonZero<Int>>, ix : NonZero<Int>) in
			let xs = x.getArray.map { $0.getNonZero }
			let i = ix.getNonZero
			return
				xs.map(%i) == xs.map { $0 % i }
				^&&^
				xs.map(i%) == xs.map { i % $0 }
		}

		property("") <- forAll { (x : ArrayOf<Int>, i : Int) in
			let xs = x.getArray
			return
				xs.map(*i) == xs.map { $0 * i }
				^&&^
				xs.map(i*) == xs.map { i * $0 }
		}

		property("") <- forAll { (x : ArrayOf<Int>, i : Int) in
			let xs = x.getArray
			return
				xs.map(+i) == xs.map { $0 + i }
				^&&^
				xs.map(i+) == xs.map { i + $0 }
		}

		property("") <- forAll { (x : ArrayOf<Positive<Int>>, ix : NonZero<Int>) in
			let xs = x.getArray.map { $0.getPositive }
			let d = ix.getNonZero

			return
				xs.map(/d) == xs.map { $0 / d }
				^&&^
				xs.map(d/) == xs.map { d / $0 }
		}

		property("") <- forAll { (x : ArrayOf<NonZero<Int>>, ix : NonZero<Int>) in
			let xs = x.getArray.map { $0.getNonZero }
			let i = ix.getNonZero
			return
				xs.map(&-i) == xs.map { $0 &- i }
				^&&^
				xs.map(i&-) == xs.map { i &- $0 }
		}

		property("") <- forAll { (x : ArrayOf<Int>, i : Int) in
			let xs = x.getArray
			return
				xs.map(&*i) == xs.map { $0 &* i }
				^&&^
				xs.map(i&*) == xs.map { i &* $0 }
		}

		property("") <- forAll { (x : ArrayOf<Int>, i : Int) in
			let xs = x.getArray
			return
				xs.map(&+i) == xs.map { $0 &+ i }
				^&&^
				xs.map(i&+) == xs.map { i &+ $0 }
		}
	}

	func testLogicalSections() {
		property("") <- forAll { (x : ArrayOf<Int>, i : Int) in
			let xs = x.getArray
			return
				xs.map(^i) == xs.map { $0 ^ i }
				^&&^
				xs.map(i^) == xs.map { i ^ $0 }
		}

		property("") <- forAll { (x : ArrayOf<Int>, i : Int) in
			let xs = x.getArray
			return
				xs.map(|i) == xs.map { $0 | i }
				^&&^
				xs.map(i|) == xs.map { i | $0 }
		}
	}

	func testEqualitySections() {
		property("") <- forAll { (x : ArrayOf<Int>, i : Int) in
			let xs = x.getArray
			return
				xs.map(==i) == xs.map { $0 == i }
				^&&^
				xs.map(i==) == xs.map { i == $0 }
		}

		property("") <- forAll { (x : ArrayOf<Int>, i : Int) in
			let xs = x.getArray
			return xs.map(!=i) == xs.map { $0 != i }
		}
	}

	func testNilCoalescingSections() {
		property("") <- forAll { (x : ArrayOf<Int>, i : Int) in
			let xs = x.getArray.map(Optional<Int>.Some).flatMap(Optional.shrink)
			return xs.map(??i) == xs.map { $0 ?? i }
		}
	}


	func testIntervalProperties() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x...11 })

		XCTAssertTrue(s.map(...11) == t, "")

		let t2 = s.map({ x in 0...x })
		XCTAssertTrue(s.map(0...) == t2, "")
	}

	func testOpenIntervalSections() {
		let s = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		let t = s.map({ x in x..<11 })

		XCTAssertTrue(s.map(..<11) == t, "")

		let t2 = s.map({ x in 0..<x })
		XCTAssertTrue(s.map(0..<) == t2, "")
	}
}
