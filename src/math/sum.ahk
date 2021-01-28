sum(param_array) {
	if (!isObject(param_array)) {
		this._internal_ThrowException()
	}

	vSum := 0
	for Key, Value in param_array {
		vSum += Value
	}
	return vSum
}


; tests
assert.test(A.sum([4, 2, 8, 6]), 20)


; omit
