Class {
	#name : #GtNotificationSudoPasswordElement,
	#superclass : #GtNotificationEventElement,
	#instVars : [
		'borderElement',
		'passwordElement',
		'password'
	],
	#category : #Gt4Binary
}

{ #category : #accessing }
GtNotificationSudoPasswordElement >> borderElement [
	^ borderElement
]

{ #category : #accessing }
GtNotificationSudoPasswordElement >> borderElement: anObject [
	borderElement := anObject
]

{ #category : #initialization }
GtNotificationSudoPasswordElement >> defaultLayout [
	^ BlLinearLayout vertical alignCenterRight
]

{ #category : #initialization }
GtNotificationSudoPasswordElement >> initialize [
	super initialize.

	self initializeBorderElement.

	self addChild: self borderElement as: #border.
	self borderElement
		containerDo: [ :aContainer | aContainer addChild: self passwordElement ].

	self
		addAptitude: (BrLayoutResizerAptitude new
				hInherit;
				vAnyToFitContent;
				hInherit: self borderElement;
				vAnyToFitContent: self borderElement)
]

{ #category : #accessing }
GtNotificationSudoPasswordElement >> initializeBorderElement [
	borderElement := GtNotificationBorderElement new
			withCloseButtonAction: [ self dismiss ]
]

{ #category : #accessing }
GtNotificationSudoPasswordElement >> password [
	^ password
]

{ #category : #accessing }
GtNotificationSudoPasswordElement >> password: anObject [
	password := anObject
]

{ #category : #initialization }
GtNotificationSudoPasswordElement >> passwordElement [
	^ passwordElement
		ifNil: [ passwordElement := self asGtMagritteViewModel asElement ]
]

{ #category : #accessing }
GtNotificationSudoPasswordElement >> sudoPasswordDescription [
	<magritteDescription>
	^ MAPasswordDescription new
		label: 'Super User Password';
		priority: 1;
		accessor: #password;
		labelAptitude: [ BrGlamorousLabelAptitude new glamorousFormLabelStyle ];
		beRequired
]
