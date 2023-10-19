Class {
	#name : #GtNotificationSudoPasswordEvent,
	#superclass : #GtNotificationEvent,
	#category : #'Gt4Binary-Message'
}

{ #category : #accessing }
GtNotificationSudoPasswordEvent >> elementClass [
	^ GtNotificationSudoPasswordElement
]

{ #category : #accessing }
GtNotificationSudoPasswordEvent >> summaryClass [
	^ GtNotificationSummary
]
