" Redline Smalltalk, Copyright (c) James C. Ladd. All rights reserved. See LICENSE in the root of this distribution "

WriteStream < #ReadWriteStream

"accessing -- reading"

- contents
    "Answer with a copy of my collection from 1 to readLimit. Overrides PositionableStream>>contents"

    readLimit := readLimit max: position.
	^collection copyFrom: 1 to: readLimit.

- next
    "Answer the next anlnteger number of objects accessible by the receiver.
    Generally, the answer will be a collection of the same class as the one
    accessed by the receiver. Overrides Stream>>next"

	<primitive: 65>

