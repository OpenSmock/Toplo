Class {
	#name : #ToImageFormLook,
	#superclass : #ToDefaultElementLook,
	#instVars : [
		'initialColor',
		'hoverColor',
		'pressedColor'
	],
	#category : #'Toplo-Core-Theme-Looks'
}

{ #category : #'event handling' }
ToImageFormLook >> adaptForegroundIn: anElement withColor: aColor [

	anElement
		withInnerFormDo: [ :form |
			| newForm |
			newForm := form collectColors: [ :color | aColor alpha: color alpha ].
			anElement innerImage: newForm ]
		ifNone: [  ]
]

{ #category : #accessing }
ToImageFormLook >> hoverColor [

	^ hoverColor
]

{ #category : #accessing }
ToImageFormLook >> hoverColor: aValuable [

	hoverColor := aValuable
]

{ #category : #'event handling' }
ToImageFormLook >> hoveredLookEvent: anEvent [

	super hoveredLookEvent: anEvent.
	self hoverColor ifNil: [ ^ self ].
	anEvent elementDo: [ :e |
		self adaptForegroundIn: e withColor: (self hoverColor value: e) ]
]

{ #category : #accessing }
ToImageFormLook >> initialColor [

	^ initialColor
]

{ #category : #accessing }
ToImageFormLook >> initialColor: aValuable [

	initialColor := aValuable
]

{ #category : #'event handling' }
ToImageFormLook >> initialLookEvent: anEvent [

	super initialLookEvent: anEvent.
	self initialColor ifNil: [ ^ self ].
	anEvent elementDo: [ :e |
		self adaptForegroundIn: e withColor: (self initialColor value: e) ]
]

{ #category : #accessing }
ToImageFormLook >> pressedColor [

	^ pressedColor
]

{ #category : #accessing }
ToImageFormLook >> pressedColor: aValuable [

	pressedColor := aValuable
]

{ #category : #'event handling' }
ToImageFormLook >> pressedLookEvent: anEvent [

	super pressedLookEvent: anEvent.
	self pressedColor ifNil: [ ^ self ].
	anEvent elementDo: [ :e |
		self adaptForegroundIn: e withColor: (self pressedColor value: e)]
]