#Include %A_ScriptDir%\..\export.ahk
#Include %A_ScriptDir%\..\node_modules
#Include unit-testing.ahk\export.ahk
#NoTrayIcon
#SingleInstance, force
SetBatchLines, -1

A := new biga()
assert := new unittesting()

; Start speed function
QPC(1)

assert.category := "chunk"
assert.label("default tests")
assert.test(A.chunk(["a", "b", "c", "d"], 2), [["a", "b"], ["c", "d"]])
assert.test(A.chunk(["a", "b", "c", "d"], 3), [["a", "b", "c"], ["d"]])

; omit
var := [1,2,3]
A.chunk(var, 2)
assert.label("parameter mutation")
assert.test(var, [1,2,3])

assert.category := "compact"
assert.label("default tests")
assert.test(A.compact([0, 1, false, 2, "", 3]), [1, 2, 3])


; omit
assert.test(A.compact([1, 2, 3, 4, 5, 6, "", "", ""]), [1, 2, 3, 4, 5, 6])

assert.category := "concat"
assert.label("default tests")
array := [1]
assert.test(A.concat(array, 2, [3], [[4]]), [1, 2, 3, [4]])
assert.test(A.concat(array), [1])

; omit
assert.test(A.concat(array, 1), [1, 1])

assert.category := "difference"
assert.label("default tests")
assert.test(A.difference([2, 1], [2, 3]), [1])

assert.test(A.difference([2, 1], [3]), [2, 1])

assert.test(A.difference([2, 1], 3), [2, 1])

; omit
assert.test(A.difference(["Barney", "Fred"], ["Fred"]), ["Barney"])
assert.test(A.difference(["Barney", "Fred"], []), ["Barney", "Fred"])
assert.test(A.difference(["Barney", "Fred"], ["Barney"], ["Fred"]), [])

assert.category := "drop"
assert.label("default tests")
assert.test(A.drop([1, 2, 3]), [2, 3])
assert.test(A.drop([1, 2, 3], 2), [3])
assert.test(A.drop([1, 2, 3], 5), [])
assert.test(A.drop([1, 2, 3], 0), [1, 2, 3])
assert.test(A.drop("fred"), ["r", "e", "d"])
assert.test(A.drop(100), ["0", "0"])


; omit
assert.test(A.drop([]), [])

assert.category := "dropRight"
assert.label("default tests")
assert.test(A.dropRight([1, 2, 3]), [1, 2])
assert.test(A.dropRight([1, 2, 3], 2), [1])
assert.test(A.dropRight([1, 2, 3], 5), [])
assert.test(A.dropRight([1, 2, 3], 0), [1, 2, 3])
assert.test(A.dropRight("fred"), ["f", "r", "e"])
assert.test(A.dropRight(100), ["1", "0"])

; omit
assert.test(A.dropRight([]), [])

assert.category := "dropRightWhile"
assert.label("default tests")
users := [ {"user": "barney", 	"active": true }
		, { "user": "fred", 	"active": false }
		, { "user": "pebbles", 	"active": false } ]
assert.test(A.dropRightWhile(users, Func("fn_dropRightWhile")), [{"user": "barney", "active": true }])
fn_dropRightWhile(o)
{
	return !o.active
}

; The `A.matches` iteratee shorthand.
assert.test(A.dropRightWhile(users, {"user": "pebbles", "active": false}), [ {"user": "barney", "active": true }, { "user": "fred", "active": false } ])

; The `A.matchesProperty` iteratee shorthand.
assert.test(A.dropRightWhile(users, ["active", false]), [  {"user": "barney", "active": true } ])

; The `A.property` iteratee shorthand.
assert.test(A.dropRightWhile(users, "active"), [ {"user": "barney", "active": true }, { "user": "fred", "active": false }, { "user": "pebbles", "active": false } ])

; omit
assert.test(A.dropRightWhile([]), [])
; check that input has not been mutated
assert.test(users[3], { "user": "pebbles", 	"active": false })

assert.category := "dropWhile"
assert.label("default tests")
users := [ {"user": "barney", 	"active": false }
		, { "user": "fred", 	"active": false }
		, { "user": "pebbles", 	"active": true } ]
assert.test(A.dropWhile(users, Func("fn_dropWhile")), [{ "user": "pebbles", "active": true }])
fn_dropWhile(o)
{
	return !o.active
}

; The `A.matches` iteratee shorthand.
assert.test(A.dropWhile(users, {"user": "barney", "active": false}), [ { "user": "fred", "active": false }, { "user": "pebbles", "active": true }  ])

; The `A.matchesProperty` iteratee shorthand.
assert.test(A.dropWhile(users, ["active", false]), [ {"user": "pebbles", "active": true } ])

; The `A.property` iteratee shorthand.
assert.test(A.dropWhile(users, "active"), [ {"user": "barney", "active": false }, { "user": "fred", "active": false }, { "user": "pebbles", "active": true } ])


; omit
assert.test(A.dropWhile([]), [])

assert.category := "fill"
assert.label("default tests")
array := [1, 2, 3]
assert.test(A.fill(array, "a"), ["a", "a", "a"])
assert.test(A.fill([4, 6, 8, 10], "*", 2, 3), [4, "*", "*", 10])


; omit
assert.test(A.fill([]), [])
assert.test(array, [1, 2, 3])
; ensure that mutation did not occur
assert.category := "findIndex"
assert.label("default tests")
assert.test(A.findIndex([1, 2, 1, 2], 2), 2)

; Search from the `fromIndex`.
assert.test(A.findIndex([1, 2, 1, 2], 2, 3), 4)

assert.test(A.findIndex(["fred", "barney"], "pebbles"), -1)

StringCaseSense, On
assert.test(A.findIndex(["fred", "barney"], "Fred"), -1)
assert.test(A.findIndex([{"name": "fred"}, {"name": "barney"}], {"name": "barney"}), 2)

users := [ { "user": "barney", "age": 36, "active": true }
	, { "user": "fred", "age": 40, "active": false }
	, { "user": "pebbles", "age": 1, "active": true } ]
assert.test(A.findIndex(users, Func("findIndexFunc")), 1)
findIndexFunc(o) {
	return o.user == "barney"
}


; omit
StringCaseSense, Off
assert.test(A.findIndex([{name: "fred"}, {name: "barney"}], {name: "fred"}), 1)

users := [{"user": "barney", "active": true}
	, {"user": "fred", "active": false}
	, {"user": "pebbles", "active": false}]

assert.test(A.findIndex(users, ["active", false]), 2)

assert.category := "findLastIndex"
assert.label("default tests")
users := [{"user": "barney", "active": true}
		, {"user": "fred", "active": false}
		, {"user": "pebbles", "active": false}]

assert.test(A.findLastIndex(users, {"user": "barney", "active": true}), 1)
assert.test(A.findLastIndex(users, ["active", true]), 1)
assert.test(A.findLastIndex(users, "active"), 1)


; omit
testusers := ["barney","jane","pebbles","barney","bill"]
assert.test(A.findLastIndex(testusers, "barney"), 4)
assert.test(A.findLastIndex(testusers, "jane"), 2)
assert.test(A.findLastIndex(testusers, "bill"), 5)
assert.test(A.findLastIndex(testusers, "pebbles"), 3)

assert.category := "flatten"
assert.label("default tests")
assert.test(A.flatten([1, [2, [3, [4]], 5]]), [1, 2, [3, [4]], 5])
assert.test(A.flatten([[1, 2, 3], [4, 5, 6]]), [1, 2, 3, 4, 5, 6])

; omit

assert.category := "flattenDeep"
assert.label("default tests")
assert.test(A.flattenDeep([1]), [1])
assert.test(A.flattenDeep([1, [2]]), [1, 2])
assert.test(A.flattenDeep([1, [2, [3, [4]], 5]]), [1, 2, 3, 4, 5])

; omit
assert.test(A.depthOf([1]), 1)
assert.test(A.depthOf([1, [2]]), 2)
assert.test(A.depthOf([1, [[2]]]), 3)
assert.test(A.depthOf([1, [2, [3, [4]], 5]]), 4)

assert.category := "flattenDepth"
assert.label("default tests")
assert.test(A.flattenDepth([1, [2, [3, [4]], 5]], 1), [1, 2, [3, [4]], 5])
assert.test(A.flattenDepth([1, [2, [3, [4]], 5]], 2), [1, 2, 3, [4], 5])

; omit

assert.category := "fromPairs"
assert.label("default tests")
assert.test(A.fromPairs([["a", 1], ["b", 2]]), {"a": 1, "b": 2})

assert.category := "head"
assert.label("default tests")
assert.test(A.head([1, 2, 3]), 1)
assert.test(A.head([]), "")
assert.test(A.head("fred"), "f")
assert.test(A.head(100), "1")


; omit


; aliases
assert.test(A.first([1, 2, 3]), 1)
assert.test(A.first([]), "")
assert.test(A.first("fred"), "f")
assert.test(A.first(100), "1")

assert.category := "indexOf"
assert.label("default tests")
assert.test(A.indexOf([1, 2, 1, 2], 2), 2)

; Search from the `fromIndex`.
assert.test(A.indexOf([1, 2, 1, 2], 2, 3), 4)

assert.test(A.indexOf(["fred", "barney"], "pebbles"), -1)

StringCaseSense, On
assert.test(A.indexOf(["fred", "barney"], "Fred"), -1)


; omit
StringCaseSense, Off

assert.category := "initial"
assert.label("default tests")
assert.test(A.initial([1, 2, 3]), [1, 2])
assert.test(A.initial("fred"), ["f", "r", "e"])
assert.test(A.initial(100), ["1", "0"])


; omit
assert.test(A.initial([]), [])

assert.category := "intersection"
assert.label("default tests")
assert.test(A.intersection([2, 1], [2, 3]), [2])


; omit
assert.test(A.intersection([2, 1], [2, 3], [1, 2], [2]), [2])
assert.test(A.intersection([{"name": "Barney"}, {"name": "Fred"}], [{"name": "Barney"}]), [{"name": "Barney"}])
assert.test(A.intersection([1,2,3], [0], [1,2,3]), [])
intersectionVar := [1,2,3]
assert.test(A.intersection(intersectionVar, [1]), [1])
assert.test(intersectionVar, [1,2,3])

assert.category := "join"
assert.label("default tests")
assert.test(A.join(["a", "b", "c"], "~"), "a~b~c")
assert.test(A.join(["a", "b", "c"]), "a,b,c")

assert.category := "last"
assert.label("default tests")
assert.test(A.last([1, 2, 3]), 3)
assert.test(A.last([]), "")
assert.test(A.last("fred"), "d")
assert.test(A.last(100), "0")


; omit

assert.category := "lastIndexOf"
assert.label("default tests")
assert.test(A.lastIndexOf([1, 2, 1, 2], 2), 4)

; Search from the `fromIndex`.
assert.test(A.lastIndexOf([1, 2, 1, 2], 1, 2), 1)

StringCaseSense, On
assert.test(A.lastIndexOf(["fred", "barney"], "Fred"), -1)


; omit
StringCaseSense, Off

assert.category := "nth"
assert.label("default tests")
assert.test(A.nth([1, 2, 3]), 1)
assert.test(A.nth([1, 2, 3], -3), 1)
assert.test(A.nth([1, 2, 3], 5), "")
assert.test(A.nth("fred"), "f")
assert.test(A.nth(100), "1")
assert.test(A.nth([1, 2, 3], 0), 1)


; omit
assert.test(A.nth([]), "")

assert.category := "reverse"
assert.label("default tests")
assert.test(A.reverse(["a", "b", "c"]), ["c", "b", "a"])
assert.test(A.reverse([{"foo": "bar"}, "b", "c"]), ["c", "b", {"foo": "bar"}])
assert.test(A.reverse([[1, 2, 3], "b", "c"]), ["c", "b", [1, 2, 3]])

; omit
; ensure no mutation
reverseVar := [1,2,3]
assert.test(A.reverse(reverseVar), [3, 2, 1])
assert.test(reverseVar[3], 3)

assert.category := "slice"
assert.label("default tests")
assert.test(A.slice([1, 2, 3], 1, 2), [1, 2])
assert.test(A.slice([1, 2, 3], 1), [1, 2, 3])
assert.test(A.slice([1, 2, 3], 5), [])
assert.test(A.slice("fred"), ["f", "r", "e", "d"])
assert.test(A.slice(100), ["1", "0", "0"])


; omit

assert.category := "sortedIndex"
assert.label("default tests")
assert.test(A.sortedIndex([30, 50], 40),2)
assert.test(A.sortedIndex([30, 50], 20),1)
assert.test(A.sortedIndex([30, 50], 99),3)

assert.category := "sortedUniq"
assert.label("default tests")
assert.test(A.sortedUniq([1, 1, 2]), [1, 2])


; omit
StringCaseSense, On
assert.test(A.sortedUniq(["Fred", "Barney", "barney", "barney"]), ["Fred", "Barney", "barney"])
StringCaseSense, off

arr := [1, 2, 3, 3, 4, 4, 5, 6, 7, 7, 7, 8, 8, 9, 10]
arr2 := A.sortedUniq(arr)
assert.test(arr.Count(), 15)
assert.test(arr2.Count(), 10)

assert.category := "tail"
assert.label("default tests")
assert.test(A.tail([1, 2, 3]), [2, 3])
assert.test(A.tail("fred"), ["r", "e", "d"])
assert.test(A.tail(100), ["0", "0"])

; omit
assert.test(A.tail([]), [])

assert.category := "take"
assert.label("default tests")
assert.test(A.take([1, 2, 3]), [1])
assert.test(A.take([1, 2, 3], 2), [1, 2])
assert.test(A.take([1, 2, 3], 5), [1, 2, 3])
assert.test(A.take([1, 2, 3], 0), [])
assert.test(A.take("fred"), ["f"])
assert.test(A.take(100), ["1"])
; omit
assert.test(A.take([]), [])

assert.category := "takeRight"
assert.label("default tests")
assert.test(A.takeRight([1, 2, 3]), [3])
assert.test(A.takeRight([1, 2, 3], 2), [2, 3])
assert.test(A.takeRight([1, 2, 3], 5), [1, 2, 3])
assert.test(A.takeRight([1, 2, 3], 0), [])
assert.test(A.takeRight("fred"), ["d"])
assert.test(A.takeRight(100), ["0"])

; omit
assert.test(A.takeRight([]), [])
assert.test(A.takeRight("fred", 3), ["r","e","d"])
assert.test(A.takeRight("fred", 4), ["f","r","e","d"])

assert.category := "union"
assert.label("default tests")
assert.test(A.union([2], [1, 2]), [2, 1])


; omit
assert.test(A.union(["Fred", "Barney", "barney", "barney"]), ["Fred", "Barney", "barney"])
assert.test(A.union("hello!"), ["hello!"])

assert.category := "uniq"
assert.label("default tests")
assert.test(A.uniq([2, 1, 2]), [2, 1])


; omit
assert.test(A.uniq(["Fred", "Barney", "barney", "barney"]), ["Fred", "Barney", "barney"])

arr := [70, 88, 12, 52, 27, 14, 86, 54, 24, 55, 29, 33, 33, 25, 99]
arr2 := A.uniq(arr)
assert.test(arr.Count(), 15)
assert.test(arr2.Count(), 14)

assert.category := "without"
assert.label("default tests")
assert.test(A.without([2, 1, 2, 3], 1, 2), [3])


; omit
assert.test(A.without([2, 1, 2, 3], 1), [2, 3])
assert.test(A.without([2, 1, 2, 3], 1, 2, 3), [])

assert.category := "zip"
assert.label("default tests")
assert.test(A.zip(["a", "b"], [1, 2], [true, true]),[["a", 1, true], ["b", 2, true]])


; omit
obj1 := ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
obj2 := ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
assert.test(A.zip(obj1, obj2),[["one", "one"], ["two", "two"], ["three", "three"], ["four", "four"], ["five", "five"], ["six", "six"], ["seven", "seven"], ["eight", "eight"], ["nine", "nine"], ["ten", "ten"]])

assert.category := "zipObject"
assert.label("default tests")
assert.test(A.zipObject(["a", "b"], [1, 2]), {"a": 1, "b": 2})


; omit
assert.test(A.zipObject(["a", "b", "c"], [1, 2]), {"a": 1, "b": 2, "c": ""})

assert.category := "count"
assert.label("default tests")
assert.test(A.count([1, 2, 3], 2), 1)
assert.test(A.count("pebbles", "b"), 2)
assert.test(A.count(["fred", "barney", "pebbles"], "barney"), 1)

users := [ {"user": "fred", "age": 40, "active": true}
		, {"user": "barney", "age": 36, "active": false}
		, {"user": "pebbles", "age": 1, "active": false} ]

; The `A.matches` iteratee shorthand.
assert.test(A.count(users, {"age": 1, "active": false}), 1)

; The `A.matchesProperty` iteratee shorthand.
assert.test(A.count(users, ["active", false]), 2)

; The `A.property` iteratee shorthand.
assert.test(A.count(users, "active"), 1)


; omit
assert.label("double characters")
assert.test(A.count("pebbles", "bb"), 1)
assert.label("double characters2")
assert.test(A.count("....", ".."), 2)
assert.test(A.count("   ", "test"), 0)
assert.test(A.count(1221221221, 22), 3)

assert.category := "every"
assert.label("default tests")
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

assert.category := "filter"
assert.label("default tests")
users := [{"user":"barney", "age":36, "active":true}, {"user":"fred", "age":40, "active":false}]

assert.test(A.filter(users, Func("fn_filterFunc")), [{"user":"barney", "age":36, "active":true}])
fn_filterFunc(param_iteratee) {
	if (param_iteratee.active) {
		return true
	}
}

; The A.matches shorthand
assert.test(A.filter(users, {"age": 36,"active":true}), [{"user":"barney", "age":36, "active":true}])

; The A.matchesProperty shorthand
assert.test(A.filter(users, ["active", false]), [{"user":"fred", "age":40, "active":false}])

; The A.property shorthand
assert.test(A.filter(users, "active"), [{"user":"barney", "age":36, "active":true}])


; omit
assert.test(A.filter([1,2,3,-10,1.9], Func("fn_filter2")), [2,3])
fn_filter2(param_iteratee) {
	if (param_iteratee >= 2) {
		return true
	}
}

assert.label("using value and key")
assert.test(A.filter([1,2,3,-10,1.9,"even"], Func("fn_filter3")), [2,-10,"even"])
fn_filter3(param_iteratee, param_key) {
	if (mod(param_key, 2) = 0) {
		return true
	}
}

assert.label("using value, key, and collection")
assert.test(A.filter([1,2,3,-10,1.9,"even"], Func("fn_filter4")), [2])
fn_filter4(param_iteratee, param_key, param_collection) {
	if (mod(param_key, 2) = 0 && A.indexOf(param_collection, param_iteratee / 2) != -1) {
		return true
	}
}

assert.category := "find"
assert.label("default tests")
users := [ { "user": "barney", "age": 36, "active": true }
	, { "user": "fred", "age": 40, "active": false }
	, { "user": "pebbles", "age": 1, "active": true } ]

assert.test(A.find(users, Func("fn_findFunc")), { "user": "barney", "age": 36, "active": true })
fn_findFunc(o) {
	if (o.active) {
		return true
	}
}

; The A.matches iteratee shorthand.
assert.test(A.find(users, { "age": 1, "active": true }), { "user": "pebbles", "age": 1, "active": true })

; The A.matchesProperty iteratee shorthand.
assert.test(A.find(users, ["active", false]), { "user": "fred", "age": 40, "active": false })

; The A.property iteratee shorthand.
assert.test(A.find(users, "active"), { "user": "barney", "age": 36, "active": true })


; omit
assert.test(A.find(users, "active", 2), { "user": "pebbles", "age": 1, "active": true }) ;fromindex argument

assert.category := "forEach"
assert.label("default tests")


; omit
assert.test(A.forEach([1, 2], Func("fn_forEachFunc")), [1, 2])
fn_forEachFunc(value) {
   ; msgbox, % value
}
; msgboxes `1` then `2`


; aliases
assert.test(A.each([1, 2], Func("fn_forEachFunc")), [1, 2])

assert.category := "groupBy"
assert.label("default tests")
assert.test(A.groupBy([6.1, 4.2, 6.2], A.floor), {4: [4.2], 6: [6.1, 6.2]})

assert.test(A.groupBy([6.1, 4.2, 6.3], func("Ceil")), {5: [4.2], 7: [6.1, 6.3]})

; The `A.property` iteratee shorthand.
users := [ { "user": "barney", "lastActive": "Monday" }
		, { "user": "fred", "lastActive": "Tuesday" }
		, { "user": "pebbles", "lastActive": "Tuesday" } ]
assert.test(A.groupBy(users, "lastActive"), {"Monday": [{ "user": "barney", "lastActive": "Monday" }], "Tuesday": [{ "user": "fred", "lastActive": "Tuesday" }, { "user": "pebbles", "lastActive": "Tuesday" }]})


; omit

assert.test(A.groupBy(["one", "two", "three"], A.size), {3: ["one", "two"], 5: ["three"]})

assert.category := "includes"
assert.label("default tests")
assert.true(A.includes([1, 2, 3], 1))
assert.true(A.includes({ "a": 1, "b": 2 }, 1))
assert.true(A.includes("InStr", "Str"))
StringCaseSense, On
assert.false(A.includes("InStr", "str"))
; RegEx object
assert.true(A.includes("hello!", "/\D/"))


; omit
StringCaseSense, Off
assert.false(A.includes("InStr", "Other"))

assert.category := "keyBy"
assert.label("default tests")
array := [ {"dir": "left", "code": 97}
	, {"dir": "right", "code": 100}]
assert.test(A.keyBy(array, Func("fn_keyByFunc")), {"left": {"dir": "left", "code": 97}, "right": {"dir": "right", "code": 100}})

fn_keyByFunc(value)
{
	return value.dir
}

; omit

assert.category := "map"
assert.label("default tests")
fn_square(n) {
	return  n * n
}

assert.test(A.map([4, 8], Func("fn_square")), [16, 64])
assert.test(A.map({ "a": 4, "b": 8 }, Func("fn_square")), [16, 64])
assert.test(A.map({ "a": 4, "b": 8 }), [4, 8])

; The `A.property` shorthand
users := [{ "user": "barney" }, { "user": "fred" }]
assert.test(A.map(users, "user"), ["barney", "fred"])

; omit
assert.test(A.map([" hey ", "hey", " hey	"], A.trim), ["hey", "hey", "hey"])

assert.category := "partition"
assert.label("default tests")
users := [ { "user": "barney", "age": 36, "active": false }
	, { "user": "fred", "age": 40, "active": true }
	, { "user": "pebbles", "age": 1, "active": false } ]

assert.test(A.partition(users, func("fn_partitionFunc")), [[{ "user": "fred", "age": 40, "active": true }], [{ "user": "barney", "age": 36, "active": false }, { "user": "pebbles", "age": 1, "active": false }]])
fn_partitionFunc(o) {
	return o.active
}

; The A.matches iteratee shorthand.
assert.test(A.partition(users, {"age": 1, "active": false}), [[{ "user": "pebbles", "age": 1, "active": false }], [{ "user": "barney", "age": 36, "active": false }, { "user": "fred", "age": 40, "active": true }]])

; The A.propertyMatches iteratee shorthand.
assert.test(A.partition(users, ["active", false]), [[{ "user": "barney", "age": 36, "active": false }, { "user": "pebbles", "age": 1, "active": false }] ,[{ "user": "fred", "age": 40, "active": true }]])

; The A.property iteratee shorthand.
assert.test(A.partition(users, "active"), [[{ "user": "fred", "age": 40, "active": true }], [{ "user": "barney", "age": 36, "active": false }, { "user": "pebbles", "age": 1, "active": false }]])

assert.category := "reject"
assert.label("default tests")
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

assert.category := "sample"
assert.label("default tests")


; omit
output := A.sample([1, 2, 3])
assert.test(A.size(output), 1)
assert.false(isObject(output))

output := A.sample([{"obj": 1} , {"obj": 2}, {"obj": 3}])
assert.test(A.size(output), 1)
assert.true(isObject(output))

output := A.sample([{"obj": "value"} , {"obj": "value"}, {"obj": "value"}])
assert.true(A.includes(output, "value"))

assert.category := "samplesize"
assert.label("default tests")
output := A.sampleSize([1, 2, 3], 2)
assert.test(output.Count(), 2)

output := A.sampleSize([1, 2, 3], 4)
assert.test(output.Count(), 3)


; omit
output := A.sampleSize({1:1, 8:2, "key":"value"}, 2)
assert.test(output.Count(), 2)

output := A.sampleSize({1:1, 8:2, "key":"value"}, 3)
assert.true(A.includes(output, 1))
assert.true(A.includes(output, 2))
assert.true(A.includes(output, "value"))

assert.category := "shuffle"
assert.label("default tests")


; omit
shuffleTestVar := A.shuffle([1, 2, 3, 4])
assert.test(shuffleTestVar.Count(), 4)

shuffleTestVar := A.shuffle(["barney", "fred", "pebbles"])
assert.test(shuffleTestVar.Count(), 3)

shuffleTestVar := A.shuffle([{"x": 1}, {"x": 1}, {"x": 1}])
assert.test(shuffleTestVar.Count(), 3)
assert.test(shuffleTestVar[1], {"x": 1})
assert.test(shuffleTestVar[2], {"x": 1})
assert.test(shuffleTestVar[3], {"x": 1})

assert.label("empty array")
assert.test(A.shuffle([]), [])

assert.label("sparse arrays")
shuffleTestVar := A.shuffle({2: 1, 4: 1, 6: 1})
shuffleTestVar := A.map(A.compact(shuffleTestVar))
assert.test(shuffleTestVar.Count(), 3)
assert.test(shuffleTestVar[1], 1)
assert.test(shuffleTestVar[2], 1)
assert.test(shuffleTestVar[3], 1)
shuffleTestVar := A.shuffle({2: 1, 600: 1})
shuffleTestVar := A.map(A.compact(shuffleTestVar))
assert.test(shuffleTestVar.Count(), 2)
assert.test(shuffleTestVar[1], 1)
assert.test(shuffleTestVar[2], 1)

assert.category := "size"
assert.label("default tests")
assert.test(A.size([1, 2, 3]), 3)
assert.test(A.size({ "a": 1, "b": 2 }), 2)
assert.test(A.size("pebbles"), 7)


; omit
users := [{"user": "barney", "active": true}
	, {"user": "fred", "active": false}
	, {"user": "pebbles", "active": false}]
assert.test(A.size(users), 3)

assert.category := "sortBy"
assert.label("default tests")
assert.test(A.sortBy(["b", "f", "e", "c", "d", "a"]),["a", "b", "c", "d", "e", "f"])
users := [
  , { "name": "fred",   "age": 40 }
  , { "name": "barney", "age": 34 }
  , { "name": "bernard", "age": 36 }
  , { "name": "zoey", "age": 40 }]

assert.test(A.sortBy(users, "age"), [{"age":34, "name":"barney"}, {"age":36, "name":"bernard"}, {"age":40, "name":"zoey"}, {"age":40, "name":"fred"}])
assert.test(A.sortBy(users, ["age", "name"]), [{"age":34, "name":"barney"}, {"age":36, "name":"bernard"}, {"age":40, "name":"fred"}, {"age":40, "name":"zoey"}])
assert.test(A.sortBy(users, Func("fn_sortByFunc")), [{"age":34, "name":"barney"}, {"age":36, "name":"bernard"}, {"age":40, "name":"fred"}, {"age":40, "name":"zoey"}])
fn_sortByFunc(o) {
	return o.name
}


; omit
myArray := [3, 4, 2, 9, 4, 12, 2]
assert.test(A.sortBy(myArray),[2, 2, 3, 4, 4, 9, 12])

myArray := ["100", "333", "987", "54", "1", "0", "-263", "543"]
assert.test(A.sortBy(myArray),["-263", "0", "1", "54", "100", "333", "543", "987"])

enemies := [
	, {"name": "bear", "hp": 200, "armor": 20}
	, {"name": "wolf", "hp": 100, "armor": 12}]
sortedEnemies := A.sortBy(enemies, "hp")
assert.test(A.sortBy(enemies, "hp"), [{"name": "wolf", "hp": 100, "armor": 12}, {"name": "bear", "hp": 200, "armor": 20}])

users := [
  , { "name": "fred",   "age": 46 }
  , { "name": "barney", "age": 34 }
  , { "name": "bernard", "age": 36 }
  , { "name": "Zoey", "age": 40 }]
assert.test(A.sortBy(users,"age"),[{"age":34,"name":"barney"},{"age":36,"name":"bernard"},{"age":40,"name":"Zoey"},{"age":46,"name":"fred"}])
assert.test(A.sortBy(users,"name"),[{"age":34,"name":"barney"},{"age":36,"name":"bernard"},{"age":46,"name":"fred"},{"age":40,"name":"Zoey"}])

assert.category := "internal"
assert.label("default tests")
assert.label("_internal_JSRegEx")
assert.test(A._internal_JSRegEx("/RegEx(capture)/"),"RegEx(capture)")

assert.label("md5")
assert.notEqual(A._internal_MD5({"a": [1,2,[3]]}), A._internal_MD5({"a": [1,2,[99]]}))

assert.label("type checking")
assert.true(A.isAlnum(1))
assert.true(A.isAlnum("hello"))
assert.false(A.isAlnum([]))
assert.false(A.isAlnum({}))

assert.true(A.isNumber(1))
assert.true(A.isNumber("1"))
assert.false(A.isNumber([]))
assert.false(A.isNumber({}))

assert.true(A.isFalsey(0))
assert.true(A.isFalsey(""))
assert.false(A.isFalsey([]))
assert.false(A.isFalsey({}))

; omit

assert.category := "clone"
assert.label("default tests")
object := [{ "a": 1 }, { "b": 2 }]
shallowclone := A.clone(object)
object.a := 2
assert.test(shallowclone, [{ "a": 1 }, { "b": 2 }])


; omit
var := 33
clone := A.clone(var)
clone++
assert.notEqual(var, clone)

assert.category := "cloneDeep"
assert.label("default tests")
object := [{ "a": [[1, 2, 3]] }, { "b": 2 }]
deepclone := A.cloneDeep(object)
object[1].a := 2
; object
; => [{ "a": 2 }, { "b": 2 }]
; deepclone
; => [{ "a": [[1, 2, 3]] }, { "b": 2 }]


; omit
assert.test(deepclone, [{ "a": [[1, 2, 3]] }, { "b": 2 }])
assert.test(object, [{ "a": 2 }, { "b": 2 }])

assert.category := "isEqual"
assert.label("default tests")
assert.true(A.isEqual(1, 1))
assert.true(A.isEqual({ "a": 1 }, { "a": 1 }))
assert.false(A.isEqual(1, 1, 2))
StringCaseSense, On
assert.false(A.isEqual({ "a": "a" }, { "a": "A" }))


; omit
StringCaseSense, Off
assert.false(A.isEqual({ "a": 1 }, { "a": 2 }))

assert.label("variadric parameters")
assert.true(A.isEqual(1, 1, 1))
assert.true(A.isEqual({ "a": 1 }, { "a": 1 }, { "a": 1 }))
assert.false(A.isEqual(1, 1, { "a": 1 }))

assert.label("leading zero numbers")
assert.true(A.isEqual(00011, 11))
assert.true(A.isEqual(011, 11))
assert.true(A.isEqual(11, 11))

assert.label("decimal places")
assert.true(A.isEqual(1.0, 1.000))
assert.true(A.isEqual(11, 11.000))
assert.false(A.isEqual(11, 11.0000000001))

assert.label("string comparison")
assert.true(A.isEqual(11, "11"))
assert.true(A.isEqual("11", "11"))

assert.category := "ismatch"
assert.label("default tests")
object := { "a": 1, "b": 2, "c": 3 }
assert.true(A.isMatch(object, {"b": 2}))
assert.true(A.isMatch(object, {"b": 2, "c": 3}))

assert.false(A.isMatch(object, {"b": 1}))
assert.false(A.isMatch(object, {"b": 2, "z": 99}))
assert.category := "isUndefined"
assert.label("default tests")
assert.true(A.isUndefined(""))
assert.true(A.isUndefined(non_existant_Var))
assert.false(A.isUndefined({}))
assert.false(A.isUndefined(" "))
assert.false(A.isUndefined(0))
assert.false(A.isUndefined(false))

assert.category := "add"
assert.label("default tests")
assert.test(A.add(6, 4), 10)


; omit
assert.test(A.add(10, -1), 9)
assert.test(A.add(-10, -10), -20)
assert.test(A.add(10, 0.01), 10.01)

assert.label("parameter mutation")
value := 10
A.add(value, 10)
assert.test(value, 10)
assert.category := "ceil"
assert.label("default tests")
assert.test(A.ceil(4.006), 5)
assert.test(A.ceil(6.004, 2), 6.01)
assert.test(A.ceil(6040, -2), 6100)


; omit
assert.test(A.ceil(4.1), 5)
assert.test(A.ceil(4.5), 5)
assert.test(A.ceil(41), 41)
assert.test(A.ceil(6.004, 2), 6.01)
assert.test(A.ceil(6.004, 1), 6.1)
assert.test(A.ceil(6040, -3), 7000)
assert.test(A.ceil(2.22, 2), 2.22)

assert.test(A.ceil(-2.22000000000000020, 2), -2.22)
assert.test(A.ceil(2.22000000000000020, 2), 2.23)

assert.category := "divide"
assert.label("default tests")
assert.test(A.divide(6, 4), 1.5)


; omit
assert.test(A.divide(10, -1), -10)
assert.test(A.divide(-10, -10), 1)

assert.category := "floor"
assert.label("default tests")
assert.test(A.floor(4.006), 4)
assert.test(A.floor(0.046, 2), 0.04)
assert.test(A.floor(4060, -2), 4000)


; omit
assert.test(A.floor(4.1), 4)
assert.test(A.floor(4.6), 4)
assert.test(A.floor(41), 41)
assert.test(A.floor(45), 45)
assert.test(A.floor(6.004, 2), 6.00)
assert.test(A.floor(6.004, 1), 6.0)
assert.test(A.floor(6040, -3), 6000)
assert.test(A.floor(2.22, 1), 2.2)

assert.test(A.floor(-2.22000000000000020, 2), -2.22)
assert.test(A.floor(2.22000000000000020, 2), 2.22)
assert.category := "max"
assert.label("default tests")
assert.test(A.max([4, 2, 8, 6]), 8)
assert.test(A.max([]), "")


; omit

assert.category := "mean"
assert.label("default tests")
assert.test(A.mean([4, 2, 8, 6]), 5)


; omit
assert.label("same value")
assert.test(A.mean([10, 10, 10]), 10)

assert.label("with string value")
assert.test(A.mean([10, "10", 10]), 10)

assert.label("decimals")
assert.test(A.mean([10.1, 42.2]), 26.150000000000002)

assert.category := "meanBy"
assert.label("default tests")
objects := [{"n": 4}, {"n": 2}, {"n": 8}, {"n": 6}]
assert.test(A.meanBy(objects, Func("meanByFunc1")), 5)
meanByFunc1(o)
{
	return o.n
}

; The `A.property` iteratee shorthand.
assert.test(A.meanBy(objects, "n"), 5)

; omit

assert.category := "min"
assert.label("default tests")
assert.test(A.min([4, 2, 8, 6]), 2)
assert.test(A.min([]), "")


; omit

assert.category := "multiply"
assert.label("default tests")
assert.test(A.multiply(6, 4), 24)


; omit
assert.label("negative numbers")
assert.test(A.multiply(10, -1), -10)
assert.test(A.multiply(-10, -10), 100)

assert.category := "round"
assert.label("default tests")
assert.label("without precision")
assert.test(A.round(4.006), 4)
assert.label("with precision")
assert.test(A.round(4.006, 2), 4.01)
assert.test(A.round(4060, -2), 4100)


; omit

assert.category := "subtract"
assert.label("default tests")
assert.test(A.subtract(6, 4), 2)


; omit
assert.label("negtive number")
assert.test(A.subtract(10, -1), 11)
assert.test(A.subtract(-10, -10), 0)

assert.label("decimal")
assert.test(A.subtract(10, 0.01), 9.99)

assert.label("parameter mutation")
g_value := 10
assert.test(A.subtract(g_value, 10), 0)
assert.test(g_value, 10)

assert.category := "sum"
assert.label("default tests")
assert.test(A.sum([4, 2, 8, 6]), 20)


; omit

assert.category := "clamp"
assert.label("default tests")
assert.test(A.clamp(-10, -5, 5), -5)
assert.test(A.clamp(10, -5, 5), 5)


; omit
; ensure no change to params
var := -10
assert.test(A.clamp(var, -5, 5), -5)
assert.test(var, -10)

assert.label("parameter mutation")
value := 10
A.clamp(value, -5, 5)
assert.test(value, 10)

assert.category := "inRange"
assert.label("default tests")
assert.test(A.inRange(3, 2, 4), true)
assert.test(A.inRange(4, 0, 8), true)
assert.test(A.inRange(4, 0, 2), false)
assert.test(A.inRange(2, 0, 2), false)
assert.test(A.inRange(1.2, 0, 2), true)
assert.test(A.inRange(5.2, 0, 4), false)
assert.test(A.inRange(-3, -2, -6), true)


; omit

assert.category := "random"
assert.label("default tests")


; omit
output := A.random(0, 1)
assert.false(isObject(output))

; test that floating point is returned
output := A.random(0, 1, true)
assert.test(A.includes(output, "."), true)

assert.category := "defaults"
assert.label("default tests")
assert.test(A.defaults({"a": 1}, {"b": 2}, {"a": 3}), {"a": 1, "b": 2})


; omit
object := {"a": 1}
assert.test(A.defaults(object, {"b": 2, "c": 3}), {"a": 1, "b": 2, "c": 3})
assert.test(object, {"a": 1})

assert.category := "keys"
assert.label("default tests")
object := {"a": 1, "b": 2, "c": 3}
assert.test(A.keys(object), ["a", "b", "c"])

assert.test(A.keys("hi"), [1, 2])


; omit

assert.category := "merge"
assert.label("default tests")
object := {"options": [{"option1": true}]}
other := {"options": [{"option2": false}]}
assert.test(A.merge(object, other), {"options": [{"option1": true, "option2": false}]})

object := { "a": [{ "b": 2 }, { "d": 4 }] }
other := { "a": [{ "c": 3 }, { "e": 5 }] }
assert.test(A.merge(object, other), { "a": [{ "b": "2", "c": 3 }, { "d": "4", "e": 5 }] })

assert.category := "omit"
assert.label("default tests")
object := {"a": 1, "b": "2", "c": 3}
assert.test(A.omit(object, ["a", "c"]), {"b": "2"})


; omit
assert.test(A.omit(object, "a"), {"b": "2", "c": 3})

assert.category := "pick"
assert.label("default tests")
object := {"a": 1, "b": "2", "c": 3}
assert.test(A.pick(object, ["a", "c"]), {"a": 1, "c": 3})


; omit
assert.test(A.pick(object, "a"), {"a": 1})
assert.test(A.pick({ "a": {"b": 2}}, "a"), { "a": {"b": 2}})
; assert.test(A.pick({ "a": {"b": 2}}, "a.b"), {"b": 2})

assert.category := "toPairs"
assert.label("default tests")
assert.test(A.toPairs({"a": 1, "b": 2}), [["a", 1], ["b", 2]])


; omit


; aliases
assert.test(A.entries({"a": 1, "b": 2}), [["a", 1], ["b", 2]])

assert.category := "camelCase"
assert.label("default tests")
assert.test(A.camelCase("--foo-bar--"), "fooBar")
assert.test(A.camelCase("fooBar"), "fooBar")
assert.test(A.camelCase("__FOO_BAR__"), "fooBar")


; omit
assert.test(A.camelCase("_this_is_FOO_BAR__"), "thisIsFooBar")

assert.category := "endsWith"
assert.label("default tests")
assert.true(A.endsWith("abc", "c"))
assert.false(A.endsWith("abc", "b"))
assert.true(A.endsWith("abc", "b", 2))


; omit

assert.label("ahk `; comment detection")
assert.true(A.endsWith("String;", ";"))
assert.true(A.endsWith("String;", "ing;"))
assert.true(A.endsWith("String;", "String;"))

assert.label("fromIndex")
assert.true(A.endsWith("String;", "g", 6))

assert.category := "escape"
assert.label("default tests")
string := "fred, barney, & pebbles"
assert.test(A.escape(string), "fred, barney, &amp; pebbles")


; omit
assert.test(A.escape("&&&"), "&amp;&amp;&amp;")

assert.category := "kebabCase"
assert.label("default tests")
assert.test(A.kebabCase("Foo Bar"), "foo-bar")
assert.test(A.kebabCase("fooBar"), "foo-bar")
assert.test(A.kebabCase("--FOO_BAR--"), "foo-bar")


; omit
assert.test(A.kebabCase("  Foo-Bar--"), "FOO-BAR")

assert.category := "lowerCase"
assert.label("default tests")
assert.test(A.lowerCase("--Foo-Bar--"), "foo bar")
assert.test(A.lowerCase("fooBar"), "foo bar")
assert.test(A.lowerCase("__FOO_BAR__"), "foo bar")


; omit
assert.test(A.lowerCase("  Foo-Bar--"), "foo bar")

assert.category := "pad"
assert.label("default tests")
assert.test(A.pad("abc", 8), "  abc   ")
assert.test(A.pad("abc", 8, "_-"), "_-abc_-_")
assert.test(A.pad("abc", 3), "abc")


; omit
assert.test(A.pad("abc", 4), "abc ")
assert.test(A.pad("abc", 9), "   abc   ")

assert.category := "padEnd"
assert.label("default tests")
assert.test(A.padEnd("abc", 6), "abc   ")
assert.test(A.padEnd("abc", 6, "_-"), "abc_-_")
assert.test(A.padEnd("abc", 3), "abc")


; omit

assert.category := "padStart"
assert.label("default tests")
assert.test(A.padStart("abc", 6), "   abc")
assert.test(A.padStart("abc", 6, "_-"), "_-_abc")
assert.test(A.padStart("abc", 3), "abc")


; omit

assert.category := "parseInt"
assert.label("default tests")
assert.test(A.parseInt("08"), 8)
assert.test(A.map(["6", "08", "10"], A.parseInt), [6, 8, 10])


; omit
assert.test(A.parseInt("0"), 0)

assert.label("decimal places")
assert.test(A.parseInt("1.0"), 1.0)
assert.test(A.parseInt("1.0001"), 1.0001)

assert.category := "repeat"
assert.label("default tests")
assert.test(A.repeat("*", 3), "***")
assert.test(A.repeat("abc", 2), "abcabc")
assert.test(A.repeat("abc", 0), "")

assert.category := "replace"
assert.label("default tests")
assert.test(A.replace("Hi Fred", "Fred", "Barney"), "Hi Barney")
assert.test(A.replace("1234", "/(\d+)/", "numbers"), "numbers")


; omit
assert.label("blank parameters")
assert.test(A.replace("Hi Barney"), "Hi Barney")
assert.test(A.replace(), "")

assert.category := "snakeCase"
assert.label("default tests")
assert.test(A.snakeCase("Foo Bar"), "foo_bar")
assert.test(A.snakeCase("fooBar"), "foo_bar")
assert.test(A.snakeCase("--FOO-BAR--"), "foo_bar")


; omit
assert.test(A.snakeCase("  Foo-Bar--"), "FOO_BAR")

assert.category := "split"
assert.label("default tests")
assert.test(A.split("a-b-c", "-", 2), ["a", "b"])
assert.test(A.split("a--b-c", "/[\-]+/"), ["a", "b", "c"])


; omit
assert.test(A.split("concat.ahk", "."), ["concat", "ahk"])
assert.test(A.split("a--b-c", ","), ["a--b-c"])

assert.category := "startCase"
assert.label("default tests")
assert.test(A.startCase("--foo-bar--"), "Foo Bar")
assert.test(A.startCase("fooBar"), "Foo Bar")
assert.test(A.startCase("__FOO_BAR__"), "Foo Bar")

assert.category := "startsWith"
assert.label("default tests")
assert.true(A.startsWith("abc", "a"))
assert.false(A.startsWith("abc", "b"))
assert.true(A.startsWith("abc", "b", 2))
StringCaseSense, On
assert.false(A.startsWith("abc", "A"))


; omit
; set caseSensitive back to false
StringCaseSense, Off

; make sure comment detection works
assert.true(A.startsWith("; String", ";"))
assert.true(A.startsWith("; String", "; "))
assert.true(A.startsWith("; String", "; String"))

assert.category := "toLower"
assert.label("default tests")
assert.test(A.toLower("--Foo-Bar--"), "--foo-bar--")
assert.test(A.toLower("fooBar"), "foobar")
assert.test(A.toLower("__FOO_BAR__"), "__foo_bar__")

assert.category := "toUpper"
assert.label("default tests")
assert.test(A.toUpper("--foo-bar--"), "--FOO-BAR--")
assert.test(A.toUpper("fooBar"), "FOOBAR")
assert.test(A.toUpper("__foo_bar__"), "__FOO_BAR__")

assert.category := "trim"
assert.label("default tests")
assert.test(A.trim("  abc  "), "abc")
assert.test(A.trim("-_-abc-_-", "_-"), "abc")
assert.test(A.map([" foo  ", "  bar  "], A.trim), ["foo", "bar"])


; omit
assert.test(A.trim(A_Tab A_Tab "  abc  " A_Tab), "abc")

assert.category := "trimEnd"
assert.label("default tests")
assert.test(A.trimEnd("  abc  "), "  abc")
assert.test(A.trimEnd("-_-abc-_-", "_-"), "-_-abc")


; omit
assert.test(A.trimEnd("filename.txt", ".txt"), "filename")

assert.category := "trimStart"
assert.label("default tests")
assert.test(A.trimStart("  abc  "), "abc  ")
assert.test(A.trimStart("-_-abc-_-", "_-"), "abc-_-")

assert.category := "truncate"
assert.label("default tests")
string := "hi-diddly-ho there, neighborino"
assert.test(A.truncate(string), "hi-diddly-ho there, neighbor...")

assert.test(A.truncate(string, {"length": 24, "separator": " "}), "hi-diddly-ho there,...")

assert.test(A.truncate(string, {"length": 24, "separator": "/, /"}), "hi-diddly-ho there...")

; omit
string := "the quick red fox jumped into something"
assert.test(A.truncate(string, {"length": A.size(string) - 1, "omission":""}), "the quick red fox jumped into somethin")

assert.category := "unescape"
assert.label("default tests")
string := "fred, barney, &amp; pebbles"
assert.test(A.unescape(string), "fred, barney, & pebbles")


; omit
assert.test(A.unescape("&amp;&amp;&amp;"), "&&&")

assert.category := "upperCase"
assert.label("default tests")
assert.test(A.upperCase("--Foo-Bar--"), "FOO BAR")
assert.test(A.upperCase("fooBar"), "FOO BAR")
assert.test(A.upperCase("__FOO_BAR__"), "FOO BAR")


; omit
assert.test(A.upperCase("  Foo-Bar--"), "FOO BAR")

assert.category := "words"
assert.label("default tests")
assert.test(A.words("fred, barney, & pebbles"), ["fred", "barney", "pebbles"])

assert.test(A.words("fred, barney, & pebbles", "/[^, ]+/"), ["fred", "barney", "&", "pebbles"])


; omit
assert.test(A.words("One, and a two, and a one two three"), ["One", "and", "a", "two", "and", "a", "one", "two", "three"])

assert.category := "constant"
assert.label("default tests")
object := A.times(2, A.constant({"a": 1}))
; => [{"a": 1}, {"a": 1}]


; omit
assert.test(object, [{"a": 1}, {"a": 1}])
functor := A.constant({ "a": 1 })
assert.test(functor.call({ "a": 1 }), {"a": 1})

assert.label("string")
object := A.times(2, A.constant("string"))
assert.test(object, ["string", "string"])

assert.category := "matches"
assert.label("default tests")
objects := [{ "a": 1, "b": 2, "c": 3 }, { "a": 4, "b": 5, "c": 6 }]
assert.test(A.filter(objects, A.matches({ "a": 4, "c": 6 })), [{ "a": 4, "b": 5, "c": 6 }])
functor := A.matches({ "a": 4 })
assert.test(A.filter(objects, functor), [{ "a": 4, "b": 5, "c": 6 }])
assert.false(functor.call({ "a": 1 }))


; omit

assert.category := "matchesProperty"
assert.label("default tests")
objects := [{ "a": 1, "b": 2, "c": 3 }, { "a": 4, "b": 5, "c": 6 }]
assert.test(A.find(objects, A.matchesProperty("a", 4)), { "a": 4, "b": 5, "c": 6 })
assert.test(A.filter(objects, A.matchesProperty("a", 4)), [{ "a": 4, "b": 5, "c": 6 }])

objects := [{ "a": {"b": 2} }, { "a": {"b": 1} }]
assert.test(A.find(objects, A.matchesProperty(["a", "b"], 1)), { "a": {"b": 1} })

; omit
fn := A.matchesProperty("a", 1)

assert.true(fn.call({ "a": 1, "b": 2, "c": 3 }))

fn := A.matchesProperty("b", 2)
assert.true(fn.call({ "a": 1, "b": 2, "c": 3 }))
assert.false(fn.call({ "a": 1 }))
assert.false(fn.call({}))
assert.false(fn.call([]))
assert.false(fn.call(""))
assert.false(fn.call(" "))

objects := [{ "options": {"private": true} }, { "options": {"private": false} }, { "options": {"private": false} }]
assert.test(A.filter(objects, A.matchesProperty("options.private", false)), [{ "options": {"private": false} }, { "options": {"private": false} }])
assert.test(A.filter(objects, A.matchesProperty(["options", "private"], false)), [{ "options": {"private": false} }, { "options": {"private": false} }])

objects := [{ "name": "fred", "options": {"private": true} }
	, { "name": "barney", "options": {"private": false} }
	, { "name": "pebbles", "options": {"private": false} }]
assert.test(A.filter(objects, A.matchesProperty("options.private", false)), [{ "name": "barney", "options": {"private": false} }, { "name": "pebbles", "options": {"private": false} }])
assert.test(A.filter(objects, A.matchesProperty(["options", "private"], false)), [{ "name": "barney", "options": {"private": false} }, { "name": "pebbles", "options": {"private": false} }])

assert.category := "property"
assert.label("default tests")
objects := [{ "a": {"b": 2} }, { "a": {"b": 1} }]
assert.test(A.map(objects, A.property("a.b")), ["2", "1"])

objects := [{"name": "fred"}, {"name": "barney"}]
assert.test(A.map(objects, A.property("name")), ["fred", "barney"])


; omit
; assert.test(A.map(A.sortBy(objects, A.property(["a", "b"]))), [2, 1])
fn := A.property("a.b")
assert.test(fn.call({ "a": {"b": 2} }), "2")

fn := A.property("a")
assert.test(fn.call({ "a": 1, "b": 2 }), 1)

assert.category := "times"
assert.label("default tests")
assert.test(A.times(4, A.constant(0)), [0, 0, 0, 0])


; omit
;; Display test results in GUI
speed := QPC(0)
assert.fullreport()
msgbox, %speed%
ExitApp

QPC(R := 0)
{
	static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", F)
	return ! DllCall("QueryPerformanceCounter", "Int64P", Q) + (R ? (P := Q) / F : (Q - P) / F)
}
