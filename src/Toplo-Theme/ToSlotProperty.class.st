Class {
	#name : #ToSlotProperty,
	#superclass : #ToLookProperty,
	#category : #'Toplo-Theme-LookUpdater'
}

{ #category : #accessing }
ToSlotProperty class >> name: aName [ 

	^ self new
		  name: aName;
		  yourself
]

{ #category : #operating }
ToSlotProperty >> read: anObject [

	^ anObject readSlotNamed: self name
]

{ #category : #operating }
ToSlotProperty >> write: aPropertyValue to: anObject [

	anObject writeSlotNamed: self name value: aPropertyValue
]