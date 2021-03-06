﻿difference(param_array,param_values*) {
	if (!isObject(param_array)) {
		this._internal_ThrowException()
	}

	; prepare
	l_array := this.clone(param_array)

	; create
	; loop all Variadic inputs
	for i, obj in param_values {
		loop, % obj.Count() {
			foundIndex := this.indexOf(l_array, obj[A_Index])
			if (foundIndex != -1) {
				l_array.RemoveAt(foundIndex)
			}
		}
	}
	return l_array
}


; tests
assert.test(A.difference([2, 1], [2, 3]), [1])

assert.test(A.difference([2, 1], [3]), [2, 1])

assert.test(A.difference([2, 1], 3), [2, 1])

; omit
assert.test(A.difference(["Barney", "Fred"], ["Fred"]), ["Barney"])
assert.test(A.difference(["Barney", "Fred"], []), ["Barney", "Fred"])
assert.test(A.difference(["Barney", "Fred"], ["Barney"], ["Fred"]), [])
