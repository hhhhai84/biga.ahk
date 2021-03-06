every(param_collection,param_predicate) {
	if (!isObject(param_collection)) {
		this._internal_ThrowException()
	}

	; prepare
	l_array := []
	shorthand := this._internal_differenciateShorthand(param_predicate, param_collection)
	if (shorthand != false) {
		boundFunc := this._internal_createShorthandfn(param_predicate, param_collection)
	}
	if (param_predicate.maxParams > 0) {
		boundFunc := param_predicate.bind()
	}

	; create
	for Key, Value in param_collection {
		if (shorthand != false) {
			if (boundFunc.call(Value, Key, param_collection) == true) {
				continue
			}
			return false
		}
		if (param_predicate.call(Value, Key, param_collection) == true) {
			continue
		}
	}
	return true
}


; tests
users := [{ "user": "barney", "age": 36, "active": false }, { "user": "fred", "age": 40, "active": false }]

assert.true(A.every(users, func("fn_isOver18")))
fn_isOver18(x) {
	if (x.age > 18) {
		return true
	}
}

; The `A.matches` iteratee shorthand.
assert.false(A.every(users, { "user": "barney", "age": 36, "active": false }))

; The `A.matchesProperty` iteratee shorthand.
assert.true(A.every(users, ["active", false]))

; The `A.property` iteratee shorthand.
assert.false(A.every(users, "active"))


; omit
assert.true(A.every([], func("fn_istrue")))
assert.true(A.every([1, 2, 3], func("isPositive")))
isPositive(value) {
	if (value > 0) {
		return true
	}
	return false
}

assert.false(A.every([true, false, true, true], Func("fn_istrue")))
fn_istrue(value) {
	if (value != true) {
		return false
	}
	return true
}
assert.true(A.every([true, true, true, true], Func("fn_istrue")))


userVotes := [{"name":"fred", "votes": ["yes","yes"]}
			, {"name":"bill", "votes": ["no","yes"]}
			, {"name":"jake", "votes": ["no","yes"]}]

assert.false(A.every(userVotes, ["votes.1", "yes"]))
assert.true(A.every(userVotes, ["votes.2", "yes"]))


assert.label("detect all undefined array")
; assert.true(A.every(["","",""], A.isUndefined))
