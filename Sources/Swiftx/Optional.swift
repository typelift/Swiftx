//
//  Optional.swift
//  Swiftx
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

#if SWIFT_PACKAGE
	import Operadics
#endif

/// Fmap | If the Optional is `.None`, ignores the function and returns `.None`. Else if the
/// Optional is `.Some`, applies the function to its value and returns the result in a new `.Some`.
public func <^> <A, B>(f : (A) -> B, a : A?) -> B? {
	return a.map(f)
}

/// Ap | Returns the result of applying the given Optional function to a given Optional value.  If
/// the function and value both exist the result is the function applied to the value.  Else the
/// result is `.None`.
///
/// Promotes function application to an Optional function applied to an Optional value.
public func <*> <A, B>(f : ((A) -> B)?, a : A?) -> B? {
	return f.flatMap { $0 <^> a }
}

/// Bind | Returns the result of applying a function return an Optional to an Optional value.  If
/// the value is `.None` the result of this function is `.None`.  If the value is `.Some`, the
/// result is the application of the function to the value contained within.
///
/// Bind propagates any occurance of `.None` through a computation that may fail at several points.
public func >>- <A, B>(a : A?, f : (A) -> B?) -> B? {
	return a.flatMap(f)
}
