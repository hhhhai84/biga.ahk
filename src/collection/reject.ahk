reject(param_collection,param_predicate) {
	if (!isObject(param_collection)) {
		this._internal_ThrowException()
	}

	; prepare
	shorthand := this._internal_differenciateShorthand(param_predicate, param_collection)
	if (shorthand != false) {
		boundFunc := this._internal_createShorthandfn(param_predicate, param_collection)
	}
	l_array := []

	; create
	for Key, Value in param_collection {
		; functor
		; predefined !functor handling (slower as it .calls blindly)
		if (IsFunc(param_predicate)) {
			if (!param_predicate.call(Value)) {
				l_array.push(Value)
			}
			continue
		}
		; shorthand
		if (shorthand != false) {
			if (!boundFunc.call(Value)) {
				l_array.push(Value)
			}
			continue
		}
		; predefined !functor handling (slower as it .calls blindly)
		vValue := param_predicate.call(Value)
		if (!vValue) {
			l_array.push(Value)
			continue
		}
	}
	return l_array
}


; tests
users := [{"user":"barney", "age":36, "active":false}, {"user":"fred", "age":40, "active":true}]

assert.test(A.reject(users, Func("fn_rejectFunc")), [{"user":"fred", "age":40, "active":true}])
fn_rejectFunc(o) {
	return !o.active
}

; The A.matches shorthand
assert.test(A.reject(users, {"age":40, "active":true}), [{"user":"barney", "age":36, "active":false}])

; The A.matchesProperty shorthand
assert.test(A.reject(users, ["active", false]), [{"user":"fred", "age":40, "active":true}])

; The A.property shorthand
assert.test(A.reject(users, "active"), [{"user":"barney", "age":36, "active":false}])


; omit
