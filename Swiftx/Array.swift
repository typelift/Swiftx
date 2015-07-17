//
//  Array.swift
//  Swiftx
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// Fmap | Maps a function over the contents of an array and returns a new array of the resulting
/// values.
public func <^> <A, B>(f : A -> B, a : [A]) -> [B] {
	return a.map(f)
}

/// Ap | Given an [A -> B] and an [A], returns a [B]. Applies the function at each index in `f` to 
/// every index in `a` and returns the results in a new array.
public func <*> <A, B>(f : [(A -> B)], a : [A]) -> [B] {
	var re = [B]()
	for g in f {
		for h in a {
			re.append(g(h))
		}
	}
	return re
}

/// Bind | Given an [A], and a function from A -> [B], applies the function `f` to every element in
/// [A] and returns the result.
public func >>- <A, B>(a : [A], f : A -> [B]) -> [B] {
	return a.flatMap(f)
}
