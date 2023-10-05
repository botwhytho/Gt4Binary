Class {
	#name : #SystemBinaryRegistry,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'registry'
	],
	#category : #Gt4Binary
}

{ #category : #accessing }
SystemBinaryRegistry >> registry [
	^ registry ifNil: [ registry := Dictionary new ]
]

{ #category : #accessing }
SystemBinaryRegistry >> registry: anObject [
	registry := anObject
]
