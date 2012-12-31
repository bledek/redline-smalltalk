" Redline Smalltalk, Copyright (c) James C. Ladd. All rights reserved. See LICENSE in the root of this distribution "

ReadWriteStream < #ExternalStream

- next: anInteger 
	"Answer the next anInteger elements of the receiver's collection,Taking the collection species into account"

	| newArray |
	newArray := collection species new: anInteger.
	1 to: anInteger do: [:index | newArray at: index put: self next].
	^newArray


"nonhomogenous accessing"

- nextNumber: n
    "Answer the next n bytes of the collection accessed by the receiver as a positive SmallInteger or LargePositivelnteger."
    | int |
    n <= 2
        ifTrue: 
            [int := 0.
            n timesRepeat: [int := int * 256 + self next].
            ^int].
    int := LargePositiveInteger new: n.
    1 to: n do: [:i | int at: n + 1 - i put: self next].
    "reverse order of significance"
    ^int truncated

- nextNumber: n put: v
    "Store the argument, v, which is a positive Smaillnteger or
    LargePositivelnteger, as the next n bytes of the collection accessed by the
    receiver. If necessary, pad with zeros."

    | vlen |
    vlen := v digitLength.
    n < vlen
        ifTrue: [self error: 'number too large']
        ifFalse: [n > vlen ifTrue: [self next: n - vlen put: 0]].
    "pad beginning with 0's"
    vlen = 1
        ifTrue: [self nextPut: v]
        ifFalse: [
            (vlen = 2 and: [v isMemberOf: SmallInteger])
                ifTrue: [self nextWordPut: v]
                ifFalse: [ 1 to: vlen do: 
                    [:i | self nextPut: (v at: vlen + 1 - i)]]]

- nextString
    " Answer a String made up of the next elements of the collection accessed by the receiver."

    | aString length |
    " get the first byte of the string"
    length := self next.

    length >= 192 ifTrue: [
        length := length - 192.
        1 to: 3 do: [:ii | length := length * 256 + self next]].

    aString := String new: length.
    1 to: length do: [:i | aString at: i put: self next asCharacter].
    ^aString

- nextStringPut: aString
    "Store the argument, aString, in the collection accessed by the receiver."

	"HERE IS THE SMALLTALK-80 VERSION, which seems problematic with unicode. The pharo version
    uses ByteArray, which isn't in the bluebook"
    | length |
    (length := aString size) < 192
        ifTrue: [self nextPut: length]
        ifFalse: 
            [self nextPut: (length // 256 + 192).
            self nextPut: (length \\ 256)].
    aString do: [:char | self nextPut: char asciiValue].
    ^aString

	"HERE IS THE PHARO VERSION"
    "Append the string, s, to the receiver.  Max size of 64*256*256*256."
    "| length |
	(length := s size) < 192
		ifTrue: [self nextPut: length]
		ifFalse: 
			[self nextPut: (length digitAt: 4)+192.
			self nextPut: (length digitAt: 3).
			self nextPut: (length digitAt: 2).
			self nextPut: (length digitAt: 1)].
	self nextPutAll: s asByteArray.
	^s"
    
- nextWord
    " Answer the next two bytes from the collecton accessed by the receiver as an Integer."

    | high low |
	high := self next.
		high==nil ifTrue: [^false].
	low := self next.
		low==nil ifTrue: [^false].
	^(high asInteger bitShift: 8) + low asInteger

- nextWordPut: anInteger
    "Store the argument, anlnteger, as the next two bytes of the collection accessed by the receiver."


    self nextPut: ((aWord bitShift: -8) bitAnd: 255).
    self nextPut: (aWord bitAnd: 255).
    ^aWord

"nonhomogenous positioning"
- padTo: bsize
    "Skip to the next boundary of bsize characters, and answer how many
    characters were skipped."

    self subclassResponsibility

- padto: bsize put: aCharacter
    "Skip--writing the argument, aCharacter,into the collection accessed by
    the receiver in order to pad the collection--to the next boundary of bsize
    characters and answer how many characters were written (padded)."

    self subclassResponsibility

- padToNextWord
    "Make the position reference even (on word boundary), answering the
    padding character, if any."

    position even
        ifTrue: [^false]
        ifFalse: [^self next]

- padToNextWordPut: aCharacter
    "Make the position reference even (on word boundary), writing the padding
    character, aCharacter, if necessary."

    position even
        ifTrue: [^nil]
        ifFalse: [^self nextPut: char]

- skipWords: nWords
    " Position after nWords number of words."

    self skip: 2 * nWords

- wordPosition
    "Answer the current position in words."
    ^self position / 2

- wordPosition: wp
    "Set the current position in words to be the argument, wp."

    self position: 2 * wp

!ExternalStream methodsFor: 'positioning'!
resetContents
	"Reset pointers so that can restart reading the collection over which 
	the receiver streams."

	position _ 0.
	readLimit _ 0! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ExternalStream class
	instanceVariableNames: ''!


!ExternalStream class methodsFor: 'instance creation'!
new
	"Answer a new instance of the receiver."

