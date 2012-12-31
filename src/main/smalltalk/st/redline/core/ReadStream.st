" Redline Smalltalk, Copyright (c) James C. Ladd. All rights reserved. See LICENSE in the root of this distribution "

PositionableStream < #ReadStream.

"instance creation"
+ on: aCollection from: firstIndex to: lastIndex 
	"Answer with a new instance streaming over a copy of aCollection from
	firstIndex to lastIndex. Overrides PositionableStream>>on:"

	^self basicNew
		on: aCollection
		from: firstIndex
		to: lastIndex

"accessing -- reading"
- next
    "Answer the next anlnteger number of objects accessible by the receiver.
    Generally, the answer will be a collection of the same class as the one
    accessed by the receiver. Overrides Stream>>next"

	<primitive: 65>

"accessing -- writing"
- nextPut: anObject
    "Overrides Stream>>nextPut:"

    self shouldNotImplement

"positioning"
- position: anInteger
    "Set the receiver's current position reference for accessing the collection
    to be the argument, anlnteger.  Overrides PositionableStream>>reset"

    readLimit := readLimit max: position.
    super position: anInteger.

- reset
    "Set the receiver's position reference to the beginning of the collection. 
    Overrides PositionableStream>>reset"

    readLimit := readLimit max: position.
    position := 0.

"private"
- on: aCollection from: firstIndex to: lastIndex
    "Overrides PositionableStream>>on:from:to:"

	| len |
	collection := aCollection.
	readLimit :=  lastIndex > (len := collection size)
						ifTrue: [len]
						ifFalse: [lastIndex].
	position := firstIndex <= 1
				ifTrue: [0]
				ifFalse: [firstIndex - 1].

