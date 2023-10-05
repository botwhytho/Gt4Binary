Extension { #name : #AbstractFileReference }

{ #category : #'*Gt4Binary' }
AbstractFileReference >> gtBinaryTreeFor: aView [
	<gtView>
	| allBinaryFiles |
	self isDirectory ifFalse: [ ^ aView empty ].
	allBinaryFiles := self allFiles
			select: [ :each | 
				(each isExecutable and: [ each extension = '' ])
					or: [ (#('a' 'o' 'so') includes: each extension)
							or: [ each filename includesSubstring: '.so.' ] ] ]
			thenCollect: [ :each | each withParents asOrderedCollection ].
	allBinaryFiles
		do: [ :each | [ each first isChildOf: self ] whileFalse: [ each removeFirst ] ].
	^ aView columnedTree
		title: 'Binary Files' translated;
		priority: 2;
		items: [ allBinaryFiles
				flatCollectAsSet: [ :each | 
					[ each isEmpty ifTrue: [ #() ] ifFalse: [ {each removeFirst} ] ]
						on: CollectionIsEmpty
						do: [  ] ] ];
		children: [ :aChild | 
			(allBinaryFiles
				select: [ :each | 
					[ aChild contains: each last ]
						on: SubscriptOutOfBounds , MessageNotUnderstood
						do: [ false ] ]
				thenCollect: [ :each | 
					[ each isEmpty ifTrue: [ #() ] ifFalse: [ {each removeFirst} ] ]
						on: CollectionIsEmpty
						do: [  ] ]) flatten asSet ];
		column: 'Name' translated
			icon: [ :each | 
				| anIcon aName aContainer |
				anIcon := each isDirectory
						ifTrue: [ BrGlamorousIcons folder asElement ]
						ifFalse: [ BrGlamorousIcons file asElement ].

				aName := GtPhlowUtility newItemLabel.
				aName text: each basename asString.

				aContainer := BrHorizontalPane new
						alignCenter;
						fitContent.

				aContainer
					addChild: anIcon;
					addChild: aName ]
			weight: 1;
		column: 'Size' translated
			text: [ :each | 
				[ each isDirectory ifFalse: [ each humanReadableSize asString ] ifTrue: [ '--' ] ]
					on: FileException , FileSystemError
					do: [ :anException | anException return: '' ] ]
			width: 100;
		column: 'Creation' translated
			text: [ :each | 
				[ String
					streamContents: [ :s | 
						each creationTime printYMDOn: s.
						s nextPut: Character space.
						each creationTime printHMSOn: s ] ]
					on: FileException , FileSystemError
					do: [ :anException | anException return: '' ] ]
			width: 150
]
