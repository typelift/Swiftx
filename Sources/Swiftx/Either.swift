//
//  Either.swift
//  Swiftx
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

#if SWIFT_PACKAGE
	import Operadics
#endif

/// The `Either` type represents values with two possibilities: `.Left(L)` or `.Right(R)`.
///
/// The `Either` type is right-biased by convention.  That is, the `.Left` constructor is used to
/// hold errors and is generally ignored and left to propagate in combinators involving `Either`,
/// while `.Right` is used to hold a "correct" value - one that can be operated on further.
///
/// (mnemonic: "Right" also means "Correct").
public enum Either<L, R> {
	case Left(L)
	case Right(R)

	/// Much like the ?? operator for `Optional` types, takes a value and a function, and if the
	/// receiver is `.Left`, returns the value, otherwise maps the function over the value in
	/// `.Right` and returns that value.
	public func fold<B>(_ value : B, f : (R) -> B) -> B {
		return either(onLeft: const(value), onRight: f);
	}

	/// Named function for `>>-`. If the `Either` is `Left`, simply returns
	/// a new `Left` with the value of the receiver. If `Right`, applies the function `f`
	/// and returns the result.
	public func flatMap<S>(_ f : (R) -> Either<L, S>) -> Either<L, S> {
		return self >>- f
	}

	/// Case analysis for the `Either` type.
	///
	/// If the value is `.Left(a)`, apply the first function to `a`. If it is `.Right(b)`, apply the
	/// second function to `b`.
	public func either<A>(onLeft : (L) -> A, onRight : (R) -> A) -> A {
		switch self {
		case let .Left(e):
			return onLeft(e)
		case let .Right(e):
			return onRight(e)
		}
	}

	/// Determines if this `Either` value is a `Left`.
	public var isLeft : Bool {
		return left != nil
	}
	
	/// Determines if this `Either` value is a `Right`.
	public var isRight : Bool {
		return right != nil
	}
	
	/// Returns the value of `Right` if it exists otherwise nil.
	public var right : R? {
		switch self {
		case .Right(let r): return r
		default: return nil
		}
	}
	
	/// Returns the value of `Left` if it exists otherwise nil.
	public var left : L? {
		switch self {
		case .Left(let l): return l
		default: return nil
		}
	}
}

/// Fmap | Applies a function to any non-error value contained in the given `Either`.
///
/// If the `Either` is `.Left`, the given function is ignored and result of this function is `.Left`.
public func <^> <L, RA, RB>(f : (RA) -> RB, e : Either<L, RA>) -> Either<L, RB> {
	switch e {
	case let .Left(l):
		return .Left(l)
	case let .Right(r):
		return .Right(f(r))
	}
}

/// Ap | Given an `Either` containing an error value or a function, applies the function to any non-
/// error values contained in the given `Either`.
///
/// If the `Either` containing the function is `.Left` the result of this function is `.Left`.  Else
/// the result of this function is the result of `fmap`ing the function over the given `Either`.
///
/// Promotes function application to sums of values and functions applied to sums of values.
public func <*> <L, RA, RB>(f : Either<L, (RA) -> RB>, e : Either<L, RA>) -> Either<L, RB> {
	switch (f, e) {
	case let (.Left(l), _):
		return .Left(l)
	case let (.Right(f), r):
		return f <^> r
	}
}

/// Bind | Applies a function to any non-error value contained in the given `Either`.
///
/// If the `Either` is `.Left`, the given function is ignored and the result of this function is
/// `.Left`.  Else the result of this function is the application of the function to the value
/// contained in the `Either`.
public func >>- <L, RA, RB>(a : Either<L, RA>, f : (RA) -> Either<L, RB>) -> Either<L, RB> {
	switch a {
	case let .Left(l):
		return .Left(l)
	case let .Right(r):
		return f(r)
	}
}

/// MARK : Equatable

public func == <L : Equatable, R : Equatable>(lhs : Either<L, R>, rhs : Either<L, R>) -> Bool {
	switch (lhs, rhs) {
	case let (.Left(l), .Left(r)) where l == r:
		return true
	case let (.Right(l), .Right(r)) where l == r:
		return true
	default:
		return false
	}
}

public func != <L : Equatable, R : Equatable>(lhs : Either<L, R>, rhs : Either<L, R>) -> Bool {
	return !(lhs == rhs)
}
