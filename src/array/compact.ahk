compact(param_array) {
	if (!isObject(param_array)) {
		this._internal_ThrowException()
	}
	l_array := []

	; create
	for Key, Value in param_array {
		if (Value != "" && Value != 0 && Value != false) {
			l_array.push(Value)
		}
	}
	return l_array
}


; tests
assert.test(A.compact([0, 1, false, 2, "", 3]), [1, 2, 3])


; omit
assert.test(A.compact([1, 2, 3, 4, 5, 6, "", "", ""]), [1, 2, 3, 4, 5, 6])
