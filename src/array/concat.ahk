concat(param_array,param_values*) {
	if (!isObject(param_array)) {
		this._internal_ThrowException()
	}

	; prepare
	l_array := this.clone(param_array)

	; create
	for index, object in param_values {
		; push on any plain values
		if (!isObject(object)) {
			l_array.push(object)
		} else { ;push object values 1 level deep
			for index2, object2 in object {
				l_array.push(object2)
			}
		}
	}
	return l_array
}


; tests
array := [1]
assert.test(A.concat(array, 2, [3], [[4]]), [1, 2, 3, [4]])
assert.test(A.concat(array), [1])

; omit
assert.test(A.concat(array, 1), [1, 1])
