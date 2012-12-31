" Redline Smalltalk, Copyright (c) James C. Ladd. All rights reserved. See LICENSE in the root of this distribution "

Object < #Stream.

"accessing -- reading"

- next
    "Answer the next object accessible by the receiver."

    self subclassResponsibility

- next: anInteger
    "Answer the next anlnteger number of objects accessible by the receiver.
    Generally, the answer will be a collection of the same class as the one
    accessed by the receiver."

    | aCollection |
	aCollection := OrderedCollection new.
	anInteger timesRepeat: [aCollection addLast: self next].
	^aCollection

- nextMatchFor: anObject
    "Access the next object and answer whether it is equal to the argument, anObject."

    ^ anObject = self next.

- contents
    "Answer all of the objects in the collection accessed by the receiver.
    Generally, the answer will be a collection of the same class as the one
    accessed by the receiver."

    self subclassResponsibility


"accessing -- writing"

- nextPut: anObject
    "Store the argument, anObject,as the next element accessible by the
    receiver. Answer anObject."

    self subclassResponsibility

- nextPutAll: aCollection
    "Store the elements in the argument, aCollection, as the next elements
    accessible by the receiver. Answer aCollection."

    aCollection do: [:v | self nextPut: v].
	^aCollection

- next: anInteger put: anObject
    "Store the argument, anObject, as the next anlnteger number of elements
    accessible by the receiver. Answer anObject."

    anInteger timesRepeat: [self nextPut: anObject].
	^anObject

"testing"

- atEnd
    "Answer whether the receiver cannot access any more objects."

    self subclassResponsibility

"enumerating"

- do: aBlock
    "Evaluate the argument, aBIock, for each of the remaining elements that can
    be accessed by the receiver."
    
    [self atEnd] whileFalse: [aBlock value: self next].
