//
//  Array.swift
//  Swiftx
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

#if SWIFT_PACKAGE
	import Operadics
#endif

/// Fmap | Returns a new list of elements obtained by applying the given function to the entirety of
/// the given list of elements in order.
public func <^> <A, B>(f : (A) -> B, xs : [A]) -> [B] {
	return xs.map(f)
}

/// Ap | Returns the result of applying each element of the given array of functions to the entirety
/// of the list of elements, repeating until the list of functions has been exhausted.
///
/// Promotes function application to arrays of functions applied to arrays of elements.
public func <*> <A, B>(fs : [((A) -> B)], xs : [A]) -> [B] {
	return fs.flatMap({ xs.map($0) })
}

/// Bind | Returns the result of mapping the given function over the given array of elements and
/// concatenating the result.
public func >>- <A, B>(xs : [A], f : (A) -> [B]) -> [B] {
	return xs.flatMap(f)
}
