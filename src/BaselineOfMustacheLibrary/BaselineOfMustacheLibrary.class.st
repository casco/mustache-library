Class {
	#name : #BaselineOfMustacheLibrary,
	#superclass : #BaselineOf,
	#category : #BaselineOfMustacheLibrary
}

{ #category : #baselines }
BaselineOfMustacheLibrary >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec repository: 'bitbucket://casco/mustache-library'.
		self mustache: spec.
		spec
			package: 'Mustache-Library'
			with: [ spec requires: #( 'Mustache' ) ] ]
]

{ #category : #baselines }
BaselineOfMustacheLibrary >> mustache: spec [

	spec
		baseline: 'Mustache'
		with: [ spec repository: 'github://noha/mustache:v1.0/repository' ]
]
