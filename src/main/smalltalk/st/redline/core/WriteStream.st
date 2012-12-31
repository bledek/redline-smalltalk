" Redline Smalltalk, Copyright (c) James C. Ladd. All rights reserved. See LICENSE in the root of this distribution "

PositionableStream < #WriteStream
    instanceVariableNames: 'writeLimit'.

"instance creation"
+ on: aCollection from: firstIndex to: lastIndex 
	"Answer an instance of me on a copy of the argument, aCollection, 
	determined by the indices firstIndex and lastIndex. Position the instance 
	at the beginning of the collection. Overrides PositionableStream>>on:from:to:"

	^self basicNew
		on: aCollection
		from: firstIndex
		to: lastIndex

+ with: aCollection
    "Answer an instance of WriteStream accessing the argument, aCollection, but
    positioned to store the next element at the end of it."

    ^self basicNew with: aCollection

+ with: aCollection from: firstlndex to: lastlndex
    "Answer an instance of WriteStream accessing
    the subcollection of the argument, aCollection, from locaton firstlndex to
    iastlndex, but positioned to store the next element at the end of the
    subcollection."

    ^self basicNew with: (aCollection copyFrom: firstIndex to: lastIndex)

"accessing -- reading"

- contents
    "Answer with a copy of my collection from 1 to readLimit. Overrides PositionableStream>>contents"

    readLimit := readLimit max: position.
	^collection copyFrom: 1 to: position.

- next
   "Overrides Stream>>next"

   self shouldNotImplement.

"accessing -- writing"

- nextPut: anObject
    "Overrides Stream>>nextPut:"

    <primitive: 66>

- nextPutAll: aCollection
    "Overrides Stream>>nextPutAll:"
 
 	| newEnd |
 	collection class == aCollection class ifFalse:
 		[^ super nextPutAll: aCollection ].
 
 	newEnd := position + aCollection size.
 	newEnd > writeLimit ifTrue:
 		[self growTo: newEnd + 10].
 
 	collection replaceFrom: position+1 to: newEnd  with: aCollection startingAt: 1.
 	position := newEnd.
	
	^ aCollection

"character writing"
- cr
    "Store the return character as the next element of the receiver."

    self nextPut: Character cr.

- crTab
    "Store the return character and a single tab character as the next two elements of the receiver."

    self cr.
    self nextPut: Character tab.

- crTab: anInteger
    "Store the return character as the next element of the receiver, followed by anlnteger number of tab characters."
    self cr.
    anInteger timesRepeat: [self nextPut: Character tab].

- lf
    "Store the linefeed character as the next element of the receiver."

    self nextPut: Character lf.

- crlf
    "Store a return followed by a linefeed on the receiver"

    self cr; lf.
    
- space
    "Store the space character as the next element of the receiver."

    self nextPut: Character space.

- space: anInteger
    "Store anInteger space characters as the next element of the receiver."

    anInteger timesRepeat: [self space].

- tab
    "Store the tab character as the next element of the receiver."

    self nextPut: Character tab.

- space: anInteger
    "Store anInteger tab characters as the next element of the receiver."

    anInteger timesRepeat: [self tab].

"private"
- on: aCollection
    "Overrides PositionableStream>>on:"

	super on: aCollection.
	readLimit := 0.
	writeLimit := aCollection size

- on: aCollection from: firstIndex to: lastIndex
    "Overrides PositionableStream>>on:from:to:"

	| len |
	collection := aCollection.
	readLimit := 
		writeLimit := lastIndex > (len := collection size)
						ifTrue: [len]
						ifFalse: [lastIndex].
	position := firstIndex <= 1
				ifTrue: [0]
				ifFalse: [firstIndex - 1]

- with: aCollection
    "position myself to store the next element at the end of my collection."

	super on: aCollection.
	position := readLimit := writeLimit := aCollection size.
