Class {
	#name : #PSVFileNode,
	#superclass : #PSVParseNode,
	#instVars : [
		'lines',
		'eols'
	],
	#category : #'Gt4Binary-SmaCC_TSV_Parser'
}

{ #category : #generated }
PSVFileNode >> acceptVisitor: aParseVisitor [
	^ aParseVisitor visitFile: self
]

{ #category : #generated }
PSVFileNode >> compositeNodeVariables [
	^ #(#lines)
]

{ #category : #generated }
PSVFileNode >> compositeTokenVariables [
	^ #(#eols)
]

{ #category : #generated }
PSVFileNode >> eols [
	^ eols
]

{ #category : #generated }
PSVFileNode >> eols: anOrderedCollection [
	eols := anOrderedCollection
]

{ #category : #'generated-initialize-release' }
PSVFileNode >> initialize [
	super initialize.
	lines := OrderedCollection new: 2.
	eols := OrderedCollection new: 2.
]

{ #category : #generated }
PSVFileNode >> lines [
	^ lines
]

{ #category : #generated }
PSVFileNode >> lines: anOrderedCollection [
	self setParents: self lines to: nil.
	lines := anOrderedCollection.
	self setParents: self lines to: self
]
