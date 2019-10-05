## Installation

In a terminal or command line:

```bash
npm install biga.ahk
```

In your code:

```autohotkey
#Include %A_ScriptDir%\node_modules
#Include biga.ahk\export.ahk
A := new biga()
msgbox, % A.join(["a", "b", "c"], " ")
; => "a b c"
```


## ahk considerations

> [!Tip]
> These are not set in stone. A final decision will be made before or on v1.0.0 


By default `A.throwExceptions := true` Wherever type errors can be detected, biga.ahk will throw an exception pointing out the location the error occurred. Set this to `false` if you would like your script to continue without being stopped by biga.ahk

By default `A.caseSensitive := false` Wherever possible biga.ahk will refer to this concerning case sensitive decisions and comparisons. Set this to `true` to get closer to the javascript experience

By default `A.limit := -1` Wherever possible biga.ahk will refer to this concerning limiting actions not specified by method arguments. Set this to `1` to get closer to the javascript experience

## Examples

In the following example, we take on the role of a blogger, who wants to automate some features of their blog

```autohotkey
A := new biga()

blogPost := "This recipe is for a really scrumptious soup from Thailand. Grab a big bunch of lemongrass. We also need tomatoes."
; let's start by finding some interesting tags for this post. Breakup this post into an array of words and remove any duplicates
allWords := A.words(blogPost)
uniqWords := A.uniq(allWords)

; short words aren't useful for post tags. Let's remove anything that isn't at least 8 characters long
tagShortList := A.filter(uniqWords, Func("filterlengthFunc"))
filterlengthFunc(o) {
    global
    ; We use A.size to measure the length of the string. But it can measure objects too
    ; StrLen would also work fine here and remove the need for global scope in this function
    if (A.size(o) >= 8) {
        return true
    }
}

; the blog software wants all tags lowercase and in one long string separated by ","
lowercaseTags := A.map(tagShortList, A.toLower)
tags := A.join(lowercaseTags, ",")
; => "scrumptious,thailand,lemongrass,tomatoes"

; Let's pretend this blogpost was a lot longer and we only want {{3}} tags for this post.
;We can choose some tags at random from the larger collection
lessTags := A.sampleSize(lowercaseTags, 3)

; For the main page let's make a preview of the blogpost. 40 characters ought to do
postPreview := A.truncate(blogPost, 40)

; actually I prefer 15 words. You can combine different methods together for more power.
; .split creates an array limited to 15 items and .join turns it back into a string
postPreview := A.join(A.split(blogPost," ",15)," ") " [...]"
; => This recipe is for a really scrumptious soup from Thailand. Grab a big bunch of [...]
```

More examples available at: https://github.com/biga-ahk/biga.ahk/tree/master/examples