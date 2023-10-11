Class {
	#name : #PSVLineNode,
	#superclass : #PSVParseNode,
	#instVars : [
		'values',
		'pipes'
	],
	#category : #'Gt4Binary-SmaCC_TSV_Parser'
}

{ #category : #generated }
PSVLineNode >> acceptVisitor: aParseVisitor [
	^ aParseVisitor visitLine: self
]

{ #category : #generated }
PSVLineNode >> compositeTokenVariables [
	^ #(#values #pipes)
]

{ #category : #'generated-initialize-release' }
PSVLineNode >> initialize [
	super initialize.
	values := OrderedCollection new: 2.
	pipes := OrderedCollection new: 2.
]

{ #category : #generated }
PSVLineNode >> pipes [
	^ pipes
]

{ #category : #generated }
PSVLineNode >> pipes: anOrderedCollection [
	pipes := anOrderedCollection
]

{ #category : #generated }
PSVLineNode >> values [
	^ values
]

{ #category : #generated }
PSVLineNode >> values: anOrderedCollection [
	values := anOrderedCollection
]
