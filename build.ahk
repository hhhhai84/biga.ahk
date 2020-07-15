﻿SetBatchLines -1 ;Go as fast as CPU will allow
#NoTrayIcon
#SingleInstance force


#Include %A_ScriptDir%\node_modules
#Include biga.ahk\export.ahk
#Include util-misc.ahk\export.ahk
; #include json.ahk\export.ahk


; FilePaths
Readme_File := A_ScriptDir "\docs\README.md"
lib_File := A_ScriptDir "\export.ahk"
test_File := A_ScriptDir "\tests\test-all.ahk"

methods_File := A_ScriptDir "\methodslist.txt"
FileRead, methods_arr, % methods_File
methods_arr := A.compact(A.split(methods_arr, "`r`n"))

; Globals
A := new biga()
docsRegEx := "\*\*DOC\*\*([\s\S]*?)\*\*\*"
testsRegEx := "\*\*Tests\*\*([\s\S]*?)\*\*\*"
categoryRegEx := "src\\(.+)\\\w+\.\w{2,3}"
newline := "`r`n" ;do not change this as docsify needs `r

; Arrays that control doc and test output. For ommiting or only testing certain areas
ignoreMethodDocsArr := ["internal", "intersectionBy"]
ommitMethodsArr := [""]
onlyTestArr := [""]

The_Array := [] ; Holds main data
msgarray := []

; Test RegEx
testtest := "test\(A(\.\w*.*\)),\s*(.*)\)"
testtrue := "true\((.+?)(\(.+?\))\)"
testfalse := "false\((.+\.\w+)(.+\))\)"
testnotequal := "notequal\(A(\.\w*.*\)),\s*(.*)\)"


; method names
vMethodNames_Array := []

loop, Files, %A_ScriptDir%\src\*.ahk, R
{
	FileRead, The_MemoryFile, % A_LoopFileFullPath
	
	; chunk that b
	bbb := {}
	bbb.raw := The_MemoryFile
	; bbb.name := SubStr(A_LoopFileName,1,StrLen(A_LoopFileName) - 4)
	bbb.name := A.split(A_LoopFileName, ".")[1]
	; bbb.test := Fn_QuickRegEx(bbb.raw,testsRegEx)
	bbb.category := Fn_QuickRegEx(A_LoopFileFullPath, categoryRegEx)
	; msgbox, % bbb.name " -  " bbb.category
	if (bbb.category = "_head.tail") { ; skip head and tail folder
		continue
	}

	; ommit if noted
	if (InStr(bbb.raw, "###incomplete###")) {
		continue
	}
	if (foundIndex := A.indexOf(ommitMethodsArr, bbb.name) != -1) {
		continue
	}
	
	; markdown file
	markdown_File := A_LoopFileDir "\" bbb.name ".md"
	if (!FileExist(markdown_File)) {
		msgarray.push(markdown_File " does not exist")
	}
	FileRead, The_MemoryFile, % markdown_File
	bbb.doc := The_MemoryFile

	;lib
	bbb.lib := StrSplit(bbb.raw, "; tests")[1]
	; tests
	bbb.tests := StrSplit(bbb.raw, "; tests")[2]

	bbb.doc := A.replace(bbb.doc,"/\#{1,10}\s*Returns*/", "#### Returns") ;replace accidental headers
	bbb.doc := A.replace(bbb.doc,"/\#{1,10}\s*Arguments*/", "#### Arguments") ;replace accidental headers
	bbb.doc := A.replace(bbb.doc,"/\#{1,10}\s*Examples*/", "#### Example") ;replace accidental headers
	bbb.doc := A.replace(bbb.doc,");", ")") ;replace accidental js semicolons
	The_Array.push(bbb)
}
; The_Array := A.sortBy(The_Array,["name", "category"])
; Array_Gui(The_Array)
if (IsObject(msgarray)) {
	 ; msgbox, % A.join(msgarray, newline)
}

; ===============
; TESTS
; ===============

FileDelete, % test_File
test_head := fn_ReadFile(A_ScriptDir "\src\_head.tail\test_head.ahk")
test_tail := fn_ReadFile(A_ScriptDir "\src\_head.tail\test_tail.ahk")

FileAppend, %test_head%, % test_File
loop, % The_Array.Count() {
	element := The_Array[A_Index]
	; create the tests if in specific array or specific array is less than or 1
	if (A.indexOf(onlyTestArr, element.name) != -1 || A.compact(onlyTestArr).Count() == 0) {
		FileAppend, % newline "assert.label(""" element.name "()""" ")", % test_File
		FileAppend, % element.tests "`n", % test_File
	}
}
FileAppend, %test_tail%, % test_File

; ===============
; method names
; ===============
loop, % The_Array.Count() {
	element := The_Array[A_Index]
	vMethodNames_Array.push(element.name)
}
; clipboard := A.join(vMethodNames_Array, "|")
; msgbox, % A.printObj(A.difference(methods_arr, vMethodNames_Array))


; ===============
; DOCS
; ===============
FileDelete, % Readme_File
DOCS_Array := [fn_ReadFile(A_ScriptDir "\src\_head.tail\doc_head.md")]

loop, % The_Array.Count() {
	element := The_Array[A_Index]
	if (A.indexof(ignoreMethodDocsArr, element.name) != -1 || A.startsWith(element.name, "internal")) { ; skip ignored methods
		continue
	}
	; skip if category is any of the following
	if (A.isMatch(element, {"category": "external"}) || A.isMatch(element, {"category": "internal"})) {
		continue
	 }

	txt := []
	ExampleArray := []
	if (element.category != The_Array[A_Index - 1].category) {
		txt.push(newline "# **&ldquo;" A.startCase(element.category) "&rdquo; Methods**" newline)
	}
	txt.push("## " "." element.name newline element.doc newline newline)
	; if examples not staticly defined in .md file, parse tests for use in documentation
	if (!A.includes(element.doc,"Example") && A.includes(element.tests, "A.")) {
		txt.push("#### Example" newline newline "``````autohotkey" newline)
		ExampleArray := fn_BuildExample(StrSplit(element.tests, "`n"))
		ExampleArray.push("``````" newline newline)
		txt := A.concat(txt,ExampleArray)
	}
	txt.push(newline newline newline)
	DOCS_Array := A.concat(DOCS_Array,txt)
}
loop, % DOCS_Array.Count() {
	FileAppend, % DOCS_Array[A_Index], % Readme_File
}



; ===============
; LIBRARY EXPORT
; ===============

lib_array := A.map(The_Array,Func("fn_AddIndent"))
fn_AddIndent(value) {
	global
	x := A.replace(value.lib,"/m)^(.+)/",A_Tab "$1")
	x := A.replace(x,"/m`n)^([\s\n\r]*)$/","")
	x := A.replace(x,"/m`n)(^[\s\n\r]*$)/","")
	return x
}

FileDelete, % lib_File
lib_head := A.split(fn_ReadFile(A_ScriptDir "\src\_head.tail\lib_head.ahk"), "`n")
lib_tail := A.split(fn_ReadFile(A_ScriptDir "\src\_head.tail\lib_tail.ahk"), "`n")
lib_txt := A.join(A.concat(lib_head,lib_array,lib_tail),"")
; lib_txt := A.replace(lib_txt,"/(^\s*;(?:.*))(?:\r?\n\g<1>)+/","")
while (RegExMatch(lib_txt, "Om)^(\h*;.*)(?:\R\g<1>){3,}", RE_Match)) {
	lib_txt := A.replace(lib_txt, RE_Match.Value(), "")
}
FileAppend, %lib_txt%, % lib_File

; exitmsg := A.join(msgarray, "`n")
sleep, 100
Run, %test_File%
ExitApp, 1




; /--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
; functions
; \--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/


fn_BuildExample(param_tests) {
	; Input - > array containing `n separated textfile of assert.{{x}} tests
	; Output - > array suitable for export to markdown for example code
	global
	return_array := []

	for Key, Value in param_tests {
		if (A.includes(Value,"; omit")) {
			break
		}

		hey := Fn_QuickRegEx(Value,testtest,0)
		if (hey.count() = 2) {
			return_array.push("A" hey.Value(1) "`n; => " hey.Value(2) newline newline)
			continue
		}
		hey := Fn_QuickRegEx(Value,testnotequal,0)
		if (hey.count() = 2) {
			return_array.push("A" hey.Value(1) "`n; => " hey.Value(2) newline newline)
			continue
		}
		hey := Fn_QuickRegEx(Value,testtrue,0)
		if (hey.count() = 2) {
			return_array.push(hey.Value(1) hey.Value(2) "`n; => true" newline newline)
			continue
		}
		hey := Fn_QuickRegEx(Value,testfalse,0)
		if (hey.count() = 2) {
			return_array.push(hey.Value(1) hey.Value(2)"`n; => false" newline newline)
			continue
		}

		if (A.size(Value) > 1) {
			return_array.push(Value)
		}
	}
	return return_array
}

fn_ReadFile(param_FileToRead) {
	FileRead, l_MemoryFile, % param_FileToRead
	return l_MemoryFile
}
