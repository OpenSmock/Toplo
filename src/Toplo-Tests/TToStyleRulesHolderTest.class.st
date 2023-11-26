"
A TToStyleRuleHolderTest is a test class for testing the behavior of TToStyleRuleHolder
"
Class {
	#name : 'TToStyleRulesHolderTest',
	#superclass : 'TestCase',
	#category : 'Toplo-Tests-Core-StyleSheet',
	#package : 'Toplo-Tests',
	#tag : 'Core-StyleSheet'
}

{ #category : 'tests' }
TToStyleRulesHolderTest >> testAddAllStyleRules [

	| e |
	e := ToStyleRulesHolderElementForTest new.
	e addAllStyleRules: {ToStyleRule new}.
	self assert: e styleRules size equals: 1.
	e addAllStyleRules: {ToStyleRule new. ToStyleRule new}.
	self assert: e styleRules size equals: 3.

]

{ #category : 'tests' }
TToStyleRulesHolderTest >> testAddStyleRule [

	| e |
	e := ToStyleRulesHolderElementForTest new.
	e addStyleRule: ToStyleRule new.
	self assert: e styleRules size equals: 1
]

{ #category : 'tests' }
TToStyleRulesHolderTest >> testStyleRules [

	| e |
	e := ToStyleRulesHolderElementForTest new.
	self assert: e styleRules size equals: 0.

]