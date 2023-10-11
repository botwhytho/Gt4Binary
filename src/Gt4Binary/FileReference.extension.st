Extension { #name : #FileReference }

{ #category : #'*Gt4Binary' }
FileReference >> gtDependenciesFor: aView [
	<gtView>
	self isBinaryExecutable ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Dependencies';
		priority: 2;
		items: [ | lines parsed |
			lines := MyEnvironment getDependenciesFor: self.
			parsed := lines
					collect: [ :each | MyEnvironment lddDependencyParser parse: each ]
					thenSelect: #isArray.
			parsed
				collect: [ :each | 
					| aFileReference |
					aFileReference := each second asFileReference.
					SystemBinaryRegistry default registry
						at: aFileReference basename
						put: (ElfBinary new
								name: aFileReference basename;
								path: aFileReference;
								rawData: each) ] ];
		column: 'Dependencies' text: [ :each | each path pathString ]
]

{ #category : #'*Gt4Binary' }
FileReference >> gtDirectDependenciesFor2: aView [
	"<gtView>"
	self isBinaryExecutable ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Direct Dependencies';
		priority: 1;
		items: [ (MyEnvironment getDirectDependenciesFor: self)
				collect: [ :each | SystemBinaryRegistry default registry at: each ifAbsent: [ each ] ] ];
		column: 'Dependencies'
			text: [ :each | [ each path pathString ] on: MessageNotUnderstood do: [ each , '*' ] ]
]

{ #category : #'*Gt4Binary' }
FileReference >> gtDirectDependenciesFor: aView [
	<gtView>
	self isBinaryExecutable ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Direct Dependencies';
		priority: 1;
		object: (SystemBinaryRegistry default registry
				at: self basename
				ifAbsentPut: [ ElfBinary new
						name: self basename;
						path: self;
						calculateDependencies ]);
		view: #gtRawFor:
]
