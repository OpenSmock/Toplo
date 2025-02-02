Class {
	#name : #ToGeneralButtonMenuItem,
	#superclass : #ToMenuItemElement,
	#instVars : [
		'button'
	],
	#category : #'Toplo-Widget-Menu-Items'
}

{ #category : #accessing }
ToGeneralButtonMenuItem >> button [

	^ button 
]

{ #category : #accessing }
ToGeneralButtonMenuItem >> button: aButton [

	self button = aButton ifTrue: [ ^ self ].
	button ifNotNil: [ button removeFromParent ].
	button := aButton.
	button ifNotNil: [
		self addChild: button at: 1.
		aButton constraintsDo: [ :c | c linear vertical alignCenter ].
		aButton hMatchParent ]
]

{ #category : #initialization }
ToGeneralButtonMenuItem >> buttonClass [

	^ ToGeneralButton 
]

{ #category : #initialization }
ToGeneralButtonMenuItem >> buttonClickEventClass [

	^ BlMouseUpEvent
]

{ #category : #initialization }
ToGeneralButtonMenuItem >> clickEventClass [

	^ button clickEventClass
]

{ #category : #initialization }
ToGeneralButtonMenuItem >> initialize [ 

	super initialize.
	self button: self buttonClass new.
	self button takeFocusOnClick: false.
	self button clickEventClass: self buttonClickEventClass.
	self layout: self defaultLayout
]

{ #category : #'t - clickable - click behavior' }
ToGeneralButtonMenuItem >> whenClickedDo: aBlock [
	"Inform that the widget has been clicked."

	self button whenClickedDo: aBlock
]
