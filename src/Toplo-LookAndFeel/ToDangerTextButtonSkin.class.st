Class {
	#name : #ToDangerTextButtonSkin,
	#superclass : #ToTextButtonSkin,
	#category : #'Toplo-LookAndFeel-Theme-Skins-Button'
}

{ #category : #accessing }
ToDangerTextButtonSkin class >> type [

	^ #dangerText
]

{ #category : #built }
ToDangerTextButtonSkin >> builtBackgroundHover [ 

	^ self theme colorErrorBg
]

{ #category : #built }
ToDangerTextButtonSkin >> imageSkinType [

	^ ToDangerHoverImageSkin type
]

{ #category : #built }
ToDangerTextButtonSkin >> labelSkinType [

	^ ToDangerHoverLabelSkin type
]