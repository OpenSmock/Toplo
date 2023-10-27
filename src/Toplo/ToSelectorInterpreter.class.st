Class {
	#name : 'ToSelectorInterpreter',
	#superclass : 'ToElementSelectorVisitor',
	#instVars : [
		'targetStack',
		'result'
	],
	#category : 'Toplo-Core-Selector',
	#package : 'Toplo',
	#tag : 'Core-Selector'
}

{ #category : 'operating' }
ToSelectorInterpreter >> check: aSelector on: anElement [

	targetStack := Stack new.
	targetStack push: anElement.
	result := true.
	aSelector value accept: self.
	^ result
]

{ #category : 'accessing' }
ToSelectorInterpreter >> result [

	^ result
]

{ #category : 'visiting' }
ToSelectorInterpreter >> visitActionSelector: aSelector [

	result := aSelector action value: targetStack top
]

{ #category : 'visiting' }
ToSelectorInterpreter >> visitAndSelector: aSelector [

	aSelector left accept: self.
	result ifFalse: [ ^ self ].
	aSelector right accept: self.
]

{ #category : 'visiting' }
ToSelectorInterpreter >> visitChildSelector: aSelector [

	| parent |
	aSelector left accept: self.
	result ifFalse: [ ^ self ].

	result := false.
	parent := targetStack top.
	"evaluate only for children at a given depth or at any depth if selector depth is not specified "
	parent allChildrenBreadthFirstWithDepthDo: [ :child :depth |
		(aSelector depth isNil or: [ aSelector depth = depth ]) ifTrue: [
			targetStack push: child.
			aSelector right accept: self.
			targetStack pop.
			result ifTrue: [ ^ self ] ] ]
]

{ #category : 'visiting' }
ToSelectorInterpreter >> visitIdSelector: aSelector [

	result := aSelector id = targetStack top id
]

{ #category : 'visiting' }
ToSelectorInterpreter >> visitNotSelector: aSelector [

	aSelector left accept: self.
	result := result not
]

{ #category : 'visiting' }
ToSelectorInterpreter >> visitOrSelector: aSelector [

	aSelector left accept: self.
	result ifTrue: [ ^ self ].
	aSelector right accept: self.
]

{ #category : 'visiting' }
ToSelectorInterpreter >> visitParentSelector: aSelector [

	| current depth |
	aSelector left accept: self.
	result ifFalse: [ ^ self ].

	result := false.
	current := targetStack top.
	depth := aSelector depth.

	[
	current := current parent.
	current ifNil: [ ^ self ].
	depth := depth - 1.
	depth < 0 ifTrue: [ ^ self ].
	depth isZero ifTrue: [
		targetStack push: current.
		aSelector right accept: self.
		targetStack pop.
		^ self ] ] repeat
]

{ #category : 'visiting' }
ToSelectorInterpreter >> visitSiblingSelector: aSelector [

	| current |
	aSelector left accept: self.
	result ifFalse: [ ^ self ].

	result := false.
	current := targetStack top.
	current siblingsDo: [ :sib |
		targetStack push: sib.
		aSelector right accept: self.
		targetStack pop.
		result ifTrue: [ ^ self ] ]
]

{ #category : 'visiting' }
ToSelectorInterpreter >> visitTypeSelector: aSelector [

	result := (aSelector selectType: targetStack top class)
]

{ #category : 'visiting' }
ToSelectorInterpreter >> visitUniversalSelector: aSelector [

	result := true
]