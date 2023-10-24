Class {
	#name : #GtNotificationSudoPasswordEvent,
	#superclass : #GtNotificationEvent,
	#instVars : [
		'context'
	],
	#category : #'Gt4Binary-Message'
}

{ #category : #accessing }
GtNotificationSudoPasswordEvent >> context [
	^ context
]

{ #category : #accessing }
GtNotificationSudoPasswordEvent >> context: anObject [
	context := anObject
]

{ #category : #accessing }
GtNotificationSudoPasswordEvent >> elementClass [
	^ GtNotificationSudoPasswordElement
]
