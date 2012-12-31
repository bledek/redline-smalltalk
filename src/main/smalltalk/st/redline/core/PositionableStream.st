" Redline Smalltalk, Copyright (c) James C. Ladd. All rights reserved. See LICENSE in the root of this distribution "

Stream < #PositionableStream
    instanceVariableNames: 'collection position readLimit'.

"instance creation"

+ on: aCollection
    "Answer an instance of a kind of PositionableStream that streams over the
    argument, aCollection."

    ^ self basicNew on: aCollection.

+ on: aCollection from: firstIndex to: lastIndex
    "Answer an instance of a kind of PositionableStream that streams over a copy of a 
    subcollection of the argument, aCollection, from firstlndex to lastlndex."

    ^ self basicNew on: (aCollection copyFrom: firstIndex to: lastlndex).

"testing"
- atEnd
    "Answer whether the receiver cannot access any more objects."
    
    <primitive: 67>
    
- isEmpty
    "Answer true if the collection the receiver accesses has no elements;
    otherwise, answer false."

    ^ self atEnd and: [position = 0]

"accessing -- reading"

- contents
    "Answer with a copy of my collection from 1 to readLimit."

	^collection copyFrom: 1 to: readLimit


"accessing"

- peek
    "Answer the next element in the collection (as in the message next), but do
    not change the position reference. Answer nil if the receiver is at the
    end."

    | nextObject |
	self atEnd ifTrue: [^nil].
	nextObject := self next.
	position := position - 1.
	^nextObject

- peekFor: anObject
    "Determine the response to the message peek. If it is the same as the
    argument, anObject, then increment the position reference and answer
    true. Otherwise answer false and do not change the position reference."

    | nextObject |
	self atEnd ifTrue: [^false].
	nextObject := self next.
	"peek for matching element"
	anObject = nextObject ifTrue: [^true].
	"gobble it if found"
	position := position - 1.
	^false

- through: anObject
	"Answer a subcollection from position to the occurrence (if any, inclusive) of anObject. If not there, answer everything."

	| newStream element |
	newStream := WriteStream on: (collection species new: 64).
	[self atEnd]
		whileFalse:
			[element := self next.
			newStream nextPut: element.
			element = anObject ifTrue: [^newStream contents]].
	^newStream contents

- upTo: anObject
    "Answer a collection of elements starting with the next element accessed by
    the receiver, and up to, not inclusive of, the next element that is equal
    to anObject. If anObject is not in the collection, answer the entire rest
    of the collection."

    | newStream element |
	newStream := (collection species new: 100) writeStream.
	[self atEnd or: [(element := self next) = anObject]]
		whileFalse: [newStream nextPut: element].
	^newStream contents

upToEnd
	"Answer a subcollection from position to the end of anObject."

	| newStream |
	newStream := WriteStream on: (collection species new: 64).
	[self atEnd] whileFalse: [newStream nextPut: self next].
	^newStream contents

- reverseContents
    "Answer a copy of the receiver's contents in reverse order."

    |newCol|
    newCol := collection species new.
    collection reverseDo:
        [:elem | newCol addLast: elem]
        
    ^ newCol
        

"positioning"
- position
    "Answer the receiver's current position reference for accessing the collection."

    ^ position

- position: anInteger
    "Set the receiver's current position reference for accessing the collection
    to be the argument, anlnteger.If the argument is not within he bounds of
    the receiver's collection, report an error."

    (anInteger >= 0 and: [anInteger <= readLimit])
    ifTrue: [position := anInteger]
    ifFalse: [self positionError]

- reset
    "Set the receiver's position reference to the beginning of the collection."

    position := 0.

- setToEnd
    "Set the receiver's position reference to the end of the collection."

    readLimit := readLimit max: position.
    position := readLimit.

- skip: anInteger
    "Set the receiver's position reference to be the current position plus the
    argument, anlnteger, possibly adjusting the result so as to remain within
    the bounds of the collection."

    self position: position + anInteger.

- skipTo: anObject
    "Set the receiver's position reference to be past the next occurrence of
    the argument, anObject, in the collection. Answer whether such an 
    occurrence existed."

    [self atEnd]
        whileFalse: [self next = anObject ifTrue: [^true]].
    ^ false.

"private"
- on: aCollection

    collection := aCollection.
    readLimit := aCollection size.
    position := 0.
    self reset.

- positionError
	"Since I am not necessarily writable, it is up to my subclasses to override 
	position: if expanding the collection is preferrable to giving this error."

	self error: 'Attempt to set the position of a PositionableStream out of bounds'
