"
A ToStyleSheetTest is a test class for testing the behavior of ToStyleSheet
"
Class {
	#name : 'ToStyleSheetApplicationTest',
	#superclass : 'ToTestCaseWithSpace',
	#category : 'Toplo-Tests-Core-StyleSheet',
	#package : 'Toplo-Tests',
	#tag : 'Core-StyleSheet'
}

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testButtonLabelSkin0 [

	|  styleSheet button labelSkin attributes foregroundAttr prop writers label theme |
	" declare a local only stylesheet "
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.
	prop := ToPseudoProperty new name: #'text-attributes'.
	prop writer: [ :e :v |
		e text attributes:
			(BlTextAttributesBuilder new foreground: v) attributes.
		e textChanged ].


	styleSheet select: ((ToStampSelector new addStamp: #'button-label')
			  withParent:
			  (ToStampSelector new addAllStamps: #( #button #danger ))
			  atDepth: 3)
			style: [ :sr |
			 sr write: prop with: [ :e | e tokenValueNamed: #'color-error' ].
			 sr
				 when: ToDisabledLookEvent
				 write: prop
				 with: [ :e | e tokenValueNamed: #'color-text-disabled' ].
			 sr
				 when: ToInstallLookEvent
				 write: prop
				 with: [ :e | e tokenValueNamed: #'color-error' ].
			 sr
				 when: ToHoveredLookEvent
				 write: prop
				 with: [ :e | e tokenValueNamed: #'color-error-hover' ].
			 sr
				 when: ToPressedLookEvent
				 write: prop
				 with: [ :e | e tokenValueNamed: #'color-error-pressed' ] ].
			
	button := ToButton new.
	space toTheme: theme.
	space root addChild: button.
	button styleSheet: styleSheet.
	label := (ToLabel text: 'Default') defaultSkin: nil.
	label addStamp: #'button-label'.
	button label: label.
	labelSkin := ToBeeSkin new.
	self assert: (button hasStamp: #danger) not.
	self assert: (button label hasStamp: #'button-label').
	writers := theme applicableListenersFor: button label.
	" writers should be empty since the label rule expect the button 
	to be of class #danger and the label to be with style class #'button-label'"
	self assert: writers isEmpty.
	button addAllStamps: #( #button #danger ).
	writers := theme applicableListenersFor: button label.
	self assert: writers size equals: 4.

	labelSkin lookEventListeners: writers.
	button label defaultSkin: labelSkin.
	button label applySkinInstaller.
	attributes := button label text attributesAt: 1.
	self assert: attributes notEmpty.
	foregroundAttr := attributes
		                  detect: [ :eachAttribute |
		                  eachAttribute isKindOf: BlTextForegroundAttribute ]
		                  ifNone: [
			                  self fail:
				                  'should have a foreground attribute (toTheme colorError)' ].
	self
		assert: foregroundAttr paint
		equals: (button tokenValueNamed: #'color-error')
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testButtonSkin0 [

	| styleSheet button skin labelSkin attributes foregroundAttr writers label theme nb  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	" default button rule "
	styleSheet 
		select: (ToStampSelector new addStamp: #button)
		style: [ :sr |
			| p |
			p := ToFeatureProperty new name: #background.
			sr
				when: ToDisabledLookEvent
				write: p
				with: [ :e | e tokenValueNamed: #'color-bg-container-disabled' ].

			p := ToFeatureProperty new name: #border.

			sr
				when: ToDisabledLookEvent
				write: p
				with: [ :e | e tokenValueNamed: #'color-border-disabled' ].
			sr
				when: ToInstallLookEvent
				write: p
				with: [ :e | e tokenValueNamed: #'color-border' ].
			sr
				when: ToHoveredLookEvent
				write: p
				with: [ :e | e tokenValueNamed: #'color-primary-hover' ].
			sr
				when: ToPressedLookEvent
				write: p
				with: [ :e | e tokenValueNamed: #'color-primary-pressed' ] ].

	styleSheet script
		select: ((ToStampSelector new addStamp: #'button-label')
				 withParent:
				 (ToStampSelector new addAllStamps: #( #button #danger ))
				 atDepth: 3)
		style: [ :sr |
			| tp |
			tp := ToPseudoProperty new name: #'text-attributes'.
			tp writer: [ :e :v |
				e text attributes:
					(BlTextAttributesBuilder new foreground: v) attributes.
				e textChanged ].

			sr
				when: ToDisabledLookEvent
				write: tp
				with: [ :e | e tokenValueNamed: #'color-text-disabled' ].
			sr
				when: ToInstallLookEvent
				write: tp
				with: [ :e | e tokenValueNamed: #'color-error' ].
			sr
				when: ToHoveredLookEvent
				write: tp
				with: [ :e | e tokenValueNamed: #'color-error-hover' ].
			sr
				when: ToPressedLookEvent
				write: tp
				with: [ :e | e tokenValueNamed: #'color-error-pressed' ] ].

	button := ToButton new.
	space toTheme: theme.
	space root addChild: button.
	button addStamp: #button.
	button styleSheet: styleSheet.
	writers := theme applicableListenersFor: button.
	self assert: writers size equals: 5.
	skin := ToBeeSkin new.
	skin lookEventListeners: writers.
	button defaultSkin: nil.
	self assert: button installedSkin isNil.
	button defaultSkin: skin.
	button applySkinInstaller.
	self assert: button border width equals: 1.
	self assert: button border paint isColorPaint.
	self
		assert: button border paint color
		equals: (button tokenValueNamed: #'color-border').

	label := ToLabel text: 'Default'.
	label defaultSkin: nil.
	button label: label.
	labelSkin := ToStyleSheetSkin new.
	writers := theme applicableListenersFor: button label.
	nb := writers size.
	self assert: nb equals: 0.
	button label addStamp: #'button-label'.
	writers := theme applicableListenersFor: button label.
	" should be empty since the label rule expect the button to be of class #danger "
	self assert: writers size equals: nb.
	button addAllStamps: #( #button #danger ).
	writers := theme applicableListenersFor: button label.
	self assert: writers size equals: nb + 4.

	labelSkin lookEventListeners: writers.
	label defaultSkin: labelSkin.
	label applySkinInstaller.
	attributes := button label text attributesAt: 1.
	self assert: attributes notEmpty.
	foregroundAttr := attributes
		                  detect: [ :eachAttribute |
		                  eachAttribute isKindOf: BlTextForegroundAttribute ]
		                  ifNone: [
			                  self fail:
				                  'should have a foreground attribute (toTheme colorError)' ].
	self
		assert: foregroundAttr paint
		equals: (button label tokenValueNamed: #'color-error')
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testButtonSkinWithInterspace [

	| elem writers skin interspaceProp layoutProp theme styleSheet  |
	theme := ToStyleSheetTheme light.
	interspaceProp := ToPseudoProperty
		                  name: #'layout-interspace'
		                  reader: [ :e | e layout interspace ]
		                  writer: [ :e :v | e layout interspace: v ].
	layoutProp := ToFeatureProperty name: #layout.

	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	styleSheet 
		select: (ToStampSelector new addStamp: #button)
			|| (ToStampSelector new addAllStamps: #( #button #horizontal ))
		style: [ :sr |
			sr write: layoutProp with: BlLinearLayout horizontal.
			sr write: interspaceProp with: 10 ].
		
	elem := ToElement new.
	space root addChild: elem.
	elem styleSheet: styleSheet.
	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 0.
	elem addStamp: #button.
	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 2.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	elem defaultSkin: skin.
	elem applySkinInstaller.
	self assert: (elem layout isKindOf: BlLinearLayout).
	self assert: elem layout interspace equals: 10
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testEmptyStyleSheet [

	| ss ssi |
	ss := ToStyleSheet new inherits: false; yourself.
	ssi := ToStyleSheetTheme light.
	self assert: (ssi applicableListenersFor: (ToElement new)) isEmpty
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testSkinWith2LookEventActionOnSameLookEventEvent [

	| elem listeners skin styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme light.

	" here the border should be blue because only the last one is applied (for the same event) "
	styleSheet  select: (ToIdSelector new id: #a) style: [ :sr |
		sr when: ToInstallLookEvent do: [ :e | e border: (BlBorder paint: Color red width: 3) ].
		sr when: ToInstallLookEvent do: [ :e | e border: (BlBorder paint: Color blue width: 1) ] ].

	elem := ToElement new.
	space root addChild: elem.
	elem styleSheet: styleSheet.
	elem id: #a.
	listeners := theme applicableListenersFor: elem.
	self assert: listeners size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: listeners.
	elem defaultSkin: skin.
	elem applySkinInstaller.
	self assert: elem border width equals: 1.
	self assert: elem border paint isColorPaint.
	self assert: elem border paint color equals: Color blue
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testSkinWithAnUniversalRule [

	| styleSheet elem skin writers theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	styleSheet select: ToUniversalSelector new style: [ :sr |
		sr
			when: ToInstallLookEvent
			write: (ToFeatureProperty new name: #background)
			with: Color red ].
	elem := ToElement new.
	space root addChild: elem.
	elem styleSheet: styleSheet.
	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	elem defaultSkin: skin.
	elem applySkinInstaller.
	self assert: elem background paint color equals: Color red
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testSkinWithChildRule [
	" with a direct child "

	| skin parent child writers theme styleSheet  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme light.

	styleSheet 
		select: ((ToIdSelector new id: #child) withParent:
				 (ToStampSelector new addStamp: #parent))
		style: [ :sr |
			sr
				when: ToInstallLookEvent
				write: (ToFeatureProperty new name: #border)
				with: (BlBorder paint: Color red width: 3) ].


	parent := ToElement new addStamp: #parent.
	space root addChild: parent.
	parent styleSheet: styleSheet.
	child := ToElement new id: #child.
	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 0.

	parent addChild: child.
	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.
	parent applySkinInstaller.
	child applySkinInstaller.

	self assert: child border width equals: 3.
	self assert: child border paint isColorPaint.
	self assert: child border paint color equals: Color red
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testSkinWithChildRule2 [
	" with a direct child "

	| skin parent child writers subParent styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme light.

	styleSheet 
		select: ((ToIdSelector new id: #child)
				 withParent: (ToStampSelector new addStamp: #parent)
				 atDepth: 2)
		style: [ :sr |
			sr
				when: ToInstallLookEvent
				write: (ToFeatureProperty new name: #border)
				with: (BlBorder paint: Color red width: 3) ].

	parent := ToElement new addStamp: #parent.
	space root addChild: parent.
	parent styleSheet: styleSheet.
	subParent := ToElement new.
	child := ToElement new id: #child.
	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 0.

	parent addChild: subParent.
	subParent addChild: child.
	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.
	parent applySkinInstaller.
	child applySkinInstaller.
	self assert: child border width equals: 3.
	self assert: child border paint isColorPaint.
	self assert: child border paint color equals: Color red
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testSkinWithIdRule [

	| elem writers skin styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme light.

	styleSheet  select: (ToIdSelector new id: #a) style: [ :sr |
		sr
			write: (ToFeatureProperty new name: #border)
			with: (BlBorder paint: Color red width: 3) ].

	elem := ToElement new.
	space root addChild: elem.
	elem styleSheet: styleSheet.
	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 0.
	elem id: #a.
	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	elem defaultSkin: skin.
	elem applySkinInstaller.
	self assert: elem border width equals: 3.
	self assert: elem border paint isColorPaint.
	self assert: elem border paint color equals: Color red
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testSkinWithLookEventAction [

	| elem listeners skin styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme light.

	styleSheet  select: (ToIdSelector new id: #a) style: [ :sr |
		sr do: [ :e | e border: (BlBorder paint: Color red width: 3) ] ].

	elem := ToElement new.
	space root addChild: elem.
	elem styleSheet: styleSheet.
	listeners := theme applicableListenersFor: elem.
	self assert: listeners size equals: 0.
	elem id: #a.
	listeners := theme applicableListenersFor: elem.
	self assert: listeners size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: listeners.
	elem defaultSkin: skin.
	elem applySkinInstaller.
	self assert: elem border width equals: 3.
	self assert: elem border paint isColorPaint.
	self assert: elem border paint color equals: Color red
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testSkinWithLookEventAction2 [

	| elem listeners skin styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme light.

	styleSheet  select: (ToIdSelector new id: #a) style: [ :sr |
		sr when: ToInstallLookEvent do: [ :e | e border: (BlBorder paint: Color red width: 3) ] ].

	elem := ToElement new.
	space root addChild: elem.
	elem styleSheet: styleSheet.
	listeners := theme applicableListenersFor: elem.
	self assert: listeners size equals: 0.
	elem id: #a.
	listeners := theme applicableListenersFor: elem.
	self assert: listeners size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: listeners.
	elem defaultSkin: skin.
	elem applySkinInstaller.
	self assert: elem border width equals: 3.
	self assert: elem border paint isColorPaint.
	self assert: elem border paint color equals: Color red
]

{ #category : 'tests' }
ToStyleSheetApplicationTest >> testSkinWithLookEventActionMixedWithWriter [

	| elem listeners skin styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme light.

	" here the border should be blue even the lookEventAction is added after "
	styleSheet  select: (ToIdSelector new id: #a) style: [ :sr |
		sr
			write: (ToFeatureProperty new name: #border)
			with: (BlBorder paint: Color blue width: 1).
		sr when: ToInstallLookEvent do: [ :e | e border: (BlBorder paint: Color red width: 3) ] ].

	elem := ToElement new.
	space root addChild: elem.
	elem styleSheet: styleSheet.
	listeners := theme applicableListenersFor: elem.
	self assert: listeners size equals: 0.
	elem id: #a.
	listeners := theme applicableListenersFor: elem.
	self assert: listeners size equals: 2.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: listeners.
	elem defaultSkin: skin.
	elem applySkinInstaller.
	self assert: elem border width equals: 1.
	self assert: elem border paint isColorPaint.
	self assert: elem border paint color equals: Color blue
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyle0 [

	| button skin writers styleSheet theme |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme light.

	styleSheet select: #button asStampSelector style: [ :sr |
		sr write: (styleSheet property: #background) with: Color white.
		sr
			when: ToInstallLookEvent
			write: (styleSheet property: #background)
			with: [ :e | Color black ].
		sr
			when: ToDisabledLookEvent
			write: (styleSheet property: #background)
			with: [ :e | e tokenValueNamed: #'color-bg-container-disabled' ] ].

	button := ToElement new.
	button styleSheet: styleSheet.

	button addStamp: #button.
	space root addChild: button.
	writers := theme applicableListenersFor: button.
	self assert: writers size equals: 2.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	button defaultSkin: skin.
	button applySkinInstaller.
	self assert: button background paint isColorPaint.
	self assert: button background paint color equals: Color black
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithSubRules0 [

	| button skin writers styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme light.

	styleSheet select: #button asStampSelector style: [ :sr |
		sr select: #danger asStampSelector style: [
			sr write: (styleSheet property: #background) with: Color red.
			sr
				when: ToDisabledLookEvent
				write: (styleSheet property: #background)
				with: [ :e | Color red alpha: 0.1 ] ].
		sr write: (styleSheet property: #background) with: Color white.
		sr
			when: ToInstallLookEvent
			write: (styleSheet property: #background)
			with: [ :e | Color black ].
		sr
			when: ToDisabledLookEvent
			write: (styleSheet property: #background)
			with: [ :e | Color lightGray ] ].

	button := ToElement new.
	space root addChild: button.
	button styleSheet: styleSheet.

	button addStamp: #button.
	writers := theme applicableListenersFor: button.
	self assert: writers size equals: 2.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	button defaultSkin: skin.
	button applySkinInstaller.
	self assert: button background paint isColorPaint.
	self assert: button background paint color equals: Color black.

	button addStamp: #danger.
	writers := theme applicableListenersFor: button.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	button defaultSkin: skin.
	button applySkinInstaller.

	self assert: button background paint isColorPaint.
	self assert: button background paint color equals: Color red.

	button disabled: true.
	button applySkinInstaller.
	self assert: button background paint isColorPaint.
	self
		assert: button background paint color
		equals: (Color red alpha: 0.1)
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithSubRules1 [

	| elem child childchild1 childchild2 skin writers  styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	elem := ToElement new addStamp: #elem.
	space root addChild: elem.

	child := ToElement new addStamp: #child.
	childchild1 := ToElement new addStamp: #childchild1.
	childchild2 := ToElement new addStamp: #childchild2.

	child styleSheet: styleSheet.
	" default button rule "
	styleSheet select: #child asStampSelector style: [ :sr |
		sr select: sr any style: [
			sr
				write: (styleSheet property: #background)
				with: [ :e | Color red ] ] ].

	elem addChild: child.
	child addChild: childchild1.
	child addChild: childchild2.

	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.

	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.
	child applySkinInstaller.
	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color red
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithSubRules2 [

	| elem child childchild1 childchild2 skin writers styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	elem := ToElement new addStamp: #elem.
	space root addChild: elem.

	child := ToElement new addStamp: #child.
	childchild1 := ToElement new addStamp: #childchild1.
	childchild2 := ToElement new addStamp: #childchild2.

	elem styleSheet: styleSheet.
	elem addChild: child.
	child addChild: childchild1.
	child addChild: childchild2.


	" default button rule "
	styleSheet 
		select: (#child asStampSelector withParent: #elem asStampSelector)
		style: [ :sr |
			sr select: sr any style: [
				sr
					write: (styleSheet property: #background)
					with: [ :e | Color red ] ] ].


	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.

	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.

	child applySkinInstaller.
	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color red
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithSubRules22 [

	| elem child childchild1 childchild2 skin writers styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	elem := ToElement new addAllStamps: #( elem #red ).
	space root addChild: elem.

	child := ToElement new addStamp: #child.
	childchild1 := ToElement new addStamp: #childchild1.
	childchild2 := ToElement new addStamp: #childchild2.

	elem styleSheet: styleSheet.
	elem addChild: child.
	child addChild: childchild1.
	child addChild: childchild2.


	" default button rule "
	styleSheet 
		select: (#child asStampSelector withParent: #elem asStampSelector)
		style: [ :sr |
			sr select: (sr withParent: #red asStampSelector) style: [
				sr
					write: (styleSheet property: #background)
					with: [ :e | Color red ] ] ].


	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.

	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.
	child applySkinInstaller.

	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color red
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithSubRules3 [

	| elem child childchild1 childchild2 skin writers  styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	elem := ToElement new addAllStamps: #( elem #red ).
	space root addChild: elem.

	child := ToElement new addStamp: #child.
	childchild1 := ToElement new addStamp: #childchild1.
	childchild2 := ToElement new addStamp: #childchild2.

	elem styleSheet: styleSheet.
	elem addChild: child.
	child addChild: childchild1.
	child addChild: childchild2.

	" default button rule "
	styleSheet 
		select: (#child asStampSelector withParent:
				 ((#( #elem #red ) asStampSelector
					   withChild: #childchild1 asStampSelector
					   atDepth: 2) withChild: #childchild2 asStampSelector atDepth: 2))
		style: [ :sr |
			sr
				write: (styleSheet property: #background)
				with: [ :e | Color red ] ].

	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.

	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.

	child applySkinInstaller.
	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color red
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithSubRules32 [

	| elem child childchild1 childchild2 skin writers styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	elem := ToElement new addAllStamps: #( elem #red ).
	space root addChild: elem.

	child := ToElement new addStamp: #child.
	childchild1 := ToElement new addStamp: #childchild1.
	childchild2 := ToElement new addStamp: #childchild2.

	elem styleSheet: styleSheet.
	elem addChild: child.
	child addChild: childchild1.
	child addChild: childchild2.
	
	styleSheet 
		select: (#child asStampSelector withParent: #elem asStampSelector) style: [ :sr |
		          sr
			          select:
				          (((sr withParent: #red asStampSelector)
					            withChild: #childchild1 asStampSelector
					            atDepth: 1) withChild: #childchild2 asStampSelector atDepth: 1)
			          style: [
			          sr
				          write: (styleSheet property: #background)
				          with: [ :e | Color red ] ] ].

	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.

	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.

	child applySkinInstaller.
	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color red
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithSubRules33 [

	| elem child childchild1 childchild2 skin writers styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	elem := ToElement new addAllStamps: #( elem #red ).
	space root addChild: elem.

	child := ToElement new addStamp: #child.
	childchild1 := ToElement new addStamp: #childchild1.
	childchild2 := ToElement new addStamp: #childchild2.

	elem styleSheet: styleSheet.
	elem addChild: child.
	child addChild: childchild1.
	child addChild: childchild2.

	styleSheet 
		select: (#child asStampSelector withParent: #elem asStampSelector)
		style: [ :sr |
			sr
				select: ((sr withParent: #red asStampSelector) withChild: #childchild1 asStampSelector atDepth: 1)
				style: [
					sr select: (sr withChild: #childchild2 asStampSelector atDepth: 1) style: [
						sr
							write: (styleSheet property: #background)
							with: [ :e | Color red ] ] ] ].

	writers := theme applicableListenersFor: elem.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.
	writers := theme applicableListenersFor: childchild1.
	self assert: writers size equals: 0.

	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.

	child applySkinInstaller.
	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color red
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithoutSubRules1 [

	| elem child childchild1 childchild2 skin writers styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	elem := ToElement new addStamp: #elem.
	space root addChild: elem.

	child := ToElement new addStamp: #child.
	childchild1 := ToElement new addStamp: #childchild1.
	childchild2 := ToElement new addStamp: #childchild2.

	elem styleSheet: styleSheet.
	elem addChild: child.
	child addChild: childchild1.
	child addChild: childchild2.

	" default button rule "
	styleSheet  select: #child asStampSelector style: [ :sr |
		sr
			write: (styleSheet property: #background)
			with: [ :e | Color red ] ].

	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.

	child applySkinInstaller.
	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color red
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithoutSubRules2 [

	| elem child childchild1 childchild2 skin writers styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	elem := ToElement new addStamp: #elem.
	space root addChild: elem.

	child := ToElement new addStamp: #child.
	childchild1 := ToElement new addStamp: #childchild1.
	childchild2 := ToElement new addStamp: #childchild2.

	elem styleSheet: styleSheet.
	elem addChild: child.
	child addChild: childchild1.
	child addChild: childchild2.

	" default button rule "
	styleSheet  select: (#child asStampSelector withParent: #elem asStampSelector) style: [ :sr |
		          sr
			          write: (styleSheet property: #background)
			          with: [ :e | Color red ] ].


	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.

	child applySkinInstaller.
	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color red
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithoutSubRules3 [

	| elem child childchild1 childchild2 skin writers styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	elem := ToElement new addAllStamps: #( elem #red ).
	space root addChild: elem.

	child := ToElement new addStamp: #child.
	childchild1 := ToElement new addStamp: #childchild1.
	childchild2 := ToElement new addStamp: #childchild2.

	elem styleSheet: styleSheet.
	elem addChild: child.
	child addChild: childchild1.
	child addChild: childchild2.

	" default button rule "
	styleSheet 
		select: (#child asStampSelector withParent:
				 ((#( #elem #red ) asStampSelector
					   withChild: #childchild1 asStampSelector
					   atDepth: 2) withChild: #childchild2 asStampSelector atDepth: 2))
		style: [ :sr |
			sr
				write: (styleSheet property: #background)
				with: [ :e | Color red ] ].


	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.

	child applySkinInstaller.
	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color red
]

{ #category : 'tests - style sheet style' }
ToStyleSheetApplicationTest >> testStyleSheetStyleWithoutSubRules4 [

	| elem child childchild1 childchild2 writers skin styleSheet theme  |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.
	theme := ToStyleSheetTheme light.

	elem := ToElement new addAllStamps: #( #elem #red ).
	space root addChild: elem.

	child := ToElement new addStamp: #child.
	childchild1 := ToElement new addStamp: #childchild1.
	childchild2 := ToElement new addStamp: #childchild2.

	elem styleSheet: styleSheet.
	elem addChild: child.
	child addChild: childchild1.
	child addChild: childchild2.

	styleSheet 
		select: (#child asStampSelector withParent:
				 ((#( #elem #red ) asStampSelector
					   withChild: #childchild1 asStampSelector
					   atDepth: 2) withChild: #childchild2 asStampSelector atDepth: 2))
		style: [ :sr |
			sr
				when: ToInstallLookEvent
				write: (styleSheet property: #background)
				with: [ :e | Color red ] ].
	styleSheet script
		select: (#child asStampSelector withParent:
				 ((#( #elem #blue ) asStampSelector
					   withChild: #childchild1 asStampSelector
					   atDepth: 2) withChild: #childchild2 asStampSelector atDepth: 2))
		style: [ :sr |
			sr
				when: ToInstallLookEvent
				write: (styleSheet property: #background)
				with: [ :e | Color blue ] ].

	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.

	child applySkinInstaller.
	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color red.

	elem addAllStamps: #( #elem #blue ).
	elem removeStamp: #red.
	writers := theme applicableListenersFor: child.
	self assert: writers size equals: 1.
	skin := ToStyleSheetSkin new.
	skin lookEventListeners: writers.
	child defaultSkin: skin.
	child applySkinInstaller.
	self assert: child background paint isColorPaint.
	self assert: child background paint color equals: Color blue
]