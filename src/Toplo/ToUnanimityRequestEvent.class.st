Class {
	#name : #ToUnanimityRequestEvent,
	#superclass : #BlEvent,
	#instVars : [
		'sourceEvent'
	],
	#category : #'Toplo-Core'
}

{ #category : #visiting }
ToUnanimityRequestEvent >> accept [
]

{ #category : #visiting }
ToUnanimityRequestEvent >> accepted [

	^ sourceEvent notNil
]

{ #category : #visiting }
ToUnanimityRequestEvent >> deny [

	sourceEvent := nil
]

{ #category : #accessing }
ToUnanimityRequestEvent >> sourceEvent [

	^ sourceEvent
]

{ #category : #accessing }
ToUnanimityRequestEvent >> sourceEvent: aSelectionChangedEvent [

	sourceEvent := aSelectionChangedEvent
]