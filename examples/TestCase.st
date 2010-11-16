Object subclass: #TestCase
	instanceVariableNames: 'testSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit-Kernel'!
!TestCase commentStamp: '<historical>' prior: 0!
A TestCase is a Command representing the future running of a test case. Create one with the class method #selector: aSymbol, passing the name of the method to be run when the test case runs.

When you discover a new fixture, subclass TestCase, declare instance variables for the objects in the fixture, override #setUp to initialize the variables, and possibly override# tearDown to deallocate any external resources allocated in #setUp.

When you are writing a test case method, send #assert: aBoolean when you want to check for an expected value. For example, you might say "self assert: socket isOpen" to test whether or not a socket is open at a point in a test.!


!TestCase methodsFor: 'accessing' stamp: 'md 8/2/2006 10:59'!
assert: aBooleanOrBlock

	aBooleanOrBlock value ifFalse: [self signalFailure: 'Assertion failed']
			! !

!TestCase methodsFor: 'accessing' stamp: 'md 8/2/2006 11:00'!
assert: aBooleanOrBlock description: aString
	aBooleanOrBlock value ifFalse: [
		self logFailure: aString.
		TestResult failure signal: aString]
			! !

!TestCase methodsFor: 'accessing' stamp: 'md 8/2/2006 11:00'!
assert: aBooleanOrBlock description: aString resumable: resumableBoolean 
	| exception |
	aBooleanOrBlock value
		ifFalse: 
			[self logFailure: aString.
			exception := resumableBoolean
						ifTrue: [TestResult resumableFailure]
						ifFalse: [TestResult failure].
			exception signal: aString]
			! !

!TestCase methodsFor: 'accessing' stamp: 'dc 4/2/2007 18:38'!
assert: expected equals: actual
	^ self
		assert: (expected = actual)
		description: (self comparingStringBetween: expected and: actual)
! !

!TestCase methodsFor: 'accessing' stamp: 'md 8/2/2006 11:00'!
deny: aBooleanOrBlock

	self assert: aBooleanOrBlock value not
			! !

!TestCase methodsFor: 'accessing' stamp: 'md 8/2/2006 11:00'!
deny: aBooleanOrBlock description: aString
	self assert: aBooleanOrBlock value not description: aString
			! !

!TestCase methodsFor: 'accessing' stamp: 'md 8/2/2006 11:00'!
deny: aBooleanOrBlock description: aString resumable: resumableBoolean 
	self
		assert: aBooleanOrBlock value not
		description: aString
		resumable: resumableBoolean
			! !

!TestCase methodsFor: 'accessing'!
resources
	| allResources resourceQueue |
	allResources := Set new.
	resourceQueue := OrderedCollection new.
	resourceQueue addAll: self class resources.
	[resourceQueue isEmpty] whileFalse: [
		| next |
		next := resourceQueue removeFirst.
		allResources add: next.
		resourceQueue addAll: next resources].
	^allResources
			! !

!TestCase methodsFor: 'accessing'!
selector
	^testSelector
			! !

!TestCase methodsFor: 'accessing'!
should: aBlock
	self assert: aBlock value
			! !

!TestCase methodsFor: 'accessing'!
should: aBlock description: aString
	self assert: aBlock value description: aString
			! !

!TestCase methodsFor: 'accessing'!
should: aBlock raise: anExceptionalEvent 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
			! !

!TestCase methodsFor: 'accessing'!
should: aBlock raise: anExceptionalEvent description: aString 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
			! !

!TestCase methodsFor: 'accessing' stamp: 'nk 5/11/2003 10:32'!
should: aBlock raise: anExceptionalEvent whoseDescriptionDoesNotInclude: subString description: aString 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionNotContaining: subString)
		description: aString
! !

!TestCase methodsFor: 'accessing' stamp: 'nk 5/11/2003 10:24'!
should: aBlock raise: anExceptionalEvent whoseDescriptionIncludes: subString description: aString 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionContaining: subString)
		description: aString
! !

!TestCase methodsFor: 'accessing'!
shouldnt: aBlock
	self deny: aBlock value
			! !

!TestCase methodsFor: 'accessing'!
shouldnt: aBlock description: aString
	self deny: aBlock value description: aString
			! !

!TestCase methodsFor: 'accessing'!
shouldnt: aBlock raise: anExceptionalEvent 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
			! !

!TestCase methodsFor: 'accessing'!
shouldnt: aBlock raise: anExceptionalEvent description: aString 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not 		description: aString
			! !

!TestCase methodsFor: 'accessing' stamp: 'nk 5/11/2003 10:34'!
shouldnt: aBlock raise: anExceptionalEvent whoseDescriptionDoesNotInclude: subString description: aString 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionNotContaining: subString) not
		description: aString
! !

!TestCase methodsFor: 'accessing' stamp: 'nk 5/11/2003 10:34'!
shouldnt: aBlock raise: anExceptionalEvent whoseDescriptionIncludes: subString description: aString 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionContaining: subString) not
		description: aString
! !

!TestCase methodsFor: 'accessing' stamp: 'md 2/22/2006 14:26'!
signalFailure: aString
	TestResult failure signal: aString! !


!TestCase methodsFor: 'dependencies'!
addDependentToHierachy: anObject 
	"an empty method. for Composite compability with TestSuite"


			! !

!TestCase methodsFor: 'dependencies'!
removeDependentFromHierachy: anObject 
	"an empty method. for Composite compability with TestSuite"


			! !


!TestCase methodsFor: 'extensions' stamp: 'mx 3/20/2006 23:32'!
executeShould: aBlock inScopeOf: anException withExceptionDo: anotherBlock

	^[aBlock value.
 	false] 
		on: anException
		do: [:exception | 
			anotherBlock value: exception.
			exception return: true]! !

!TestCase methodsFor: 'extensions' stamp: 'mx 3/13/2006 23:21'!
fail

	^self assert: false! !

!TestCase methodsFor: 'extensions' stamp: 'md 8/2/2006 11:09'!
should: aBlock notTakeMoreThan: aDuration
    "Evaluate aBlock in a forked process and if it takes more than anInteger milliseconds
    to run we terminate the process and report a test failure.  It'' important to
    use the active process for the test failure so that the failure reporting works correctly
    in the context of the exception handlers."

    | evaluated evaluationProcess result delay testProcess |

    evaluated := false.
    delay := Delay forDuration: aDuration.
    testProcess := Processor activeProcess.
    "Create a new process to evaluate aBlock"
    evaluationProcess := [
        result := aBlock value.
        evaluated := true.
        delay unschedule.
        testProcess resume ] forkNamed: 'Process to evaluate should: notTakeMoreThanMilliseconds:'.

    "Wait the milliseconds they asked me to"
    delay wait.
    "After this point either aBlock was evaluated or not..."
    evaluated ifFalse: [
        evaluationProcess terminate.
        self assert: false description: ('Block evaluation took more than the expected <1p>' expandMacrosWith: aDuration)].
   
    ^result! !

!TestCase methodsFor: 'extensions' stamp: 'mx 3/20/2006 21:29'!
shouldFix: aBlock 

	^self should: aBlock raise: Exception! !

!TestCase methodsFor: 'extensions' stamp: 'md 8/2/2006 11:08'!
should: aBlock notTakeMoreThanMilliseconds: anInteger
    "For compatibility with other Smalltalks"

   self should: aBlock notTakeMoreThan: (Duration milliSeconds: anInteger).! !

!TestCase methodsFor: 'extensions' stamp: 'mx 3/20/2006 23:52'!
should: aBlock raise: anException withExceptionDo: anotherBlock 

	^self assert: (self executeShould: aBlock inScopeOf: anException withExceptionDo: anotherBlock)! !


!TestCase methodsFor: 'printing'!
printOn: aStream

	aStream
		nextPutAll: self class printString;
		nextPutAll: '>>#';
		nextPutAll: testSelector
			! !


!TestCase methodsFor: 'running' stamp: 'md 2/22/2006 14:27'!
debug
	self resources do: [:res | 
		res isAvailable ifFalse: [^res signalInitializationError]].
	[(self class selector: testSelector) runCase] 
		ensure: [self resources do: [:each | each reset]]
			! !

!TestCase methodsFor: 'running' stamp: 'bp 11/15/2004 18:13'!
debugAsFailure
	| semaphore |
	semaphore := Semaphore new.
	self resources do: [:res | 
		res isAvailable ifFalse: [^res signalInitializationError]].
	[semaphore wait. self resources do: [:each | each reset]] fork.
	(self class selector: testSelector) runCaseAsFailure: semaphore.! !

!TestCase methodsFor: 'running' stamp: 'md 2/22/2006 14:17'!
failureLog	
	^Transcript

			! !

!TestCase methodsFor: 'running'!
isLogging
	"By default, we're not logging failures. If you override this in 
	a subclass, make sure that you override #failureLog"
	^false
			! !

!TestCase methodsFor: 'running'!
logFailure: aString
	self isLogging ifTrue: [
		self failureLog 
			cr; 
			nextPutAll: aString; 
			flush]
			! !

!TestCase methodsFor: 'running' stamp: 'bp 11/15/2004 18:17'!
openDebuggerOnFailingTestMethod
	"SUnit has halted one step in front of the failing test method. Step over the 'self halt' and 
	 send into 'self perform: testSelector' to see the failure from the beginning"

	self
		halt;
		performTest! !

!TestCase methodsFor: 'running'!
run
	| result |
	result := TestResult new.
	self run: result.
	^result
			! !

!TestCase methodsFor: 'running' stamp: 'GwenaelCasaccio 10/1/2008 19:58'!
run: aResult 
	aResult runCase: self.
! !

!TestCase methodsFor: 'running' stamp: 'AdrianLienhard 10/19/2009 10:30'!
runCase
	Author
		useAuthor: 'TestRunner'
		during: [
			[self setUp.
			self performTest]
				ensure: [
					self tearDown.
					self cleanUpInstanceVariables ] ]! !

!TestCase methodsFor: 'running' stamp: 'md 2/22/2006 14:27'!
runCaseAsFailure: aSemaphore
	[self setUp.
	self openDebuggerOnFailingTestMethod] ensure: [
		self tearDown.
		aSemaphore signal]! !

!TestCase methodsFor: 'running' stamp: 'DavidRoethlisberger 11/10/2008 09:54'!
setUp! !

!TestCase methodsFor: 'running' stamp: 'DavidRoethlisberger 11/10/2008 09:54'!
tearDown! !


!TestCase methodsFor: 'testing' stamp: 'JF 7/30/2003 13:40'!
expectedFailures
	^ Array new! !

!TestCase methodsFor: 'testing' stamp: 'JF 7/30/2003 13:39'!
shouldPass
	"Unless the selector is in the list we get from #expectedFailures, we expect it to pass"
	^ (self expectedFailures includes: testSelector) not! !


!TestCase methodsFor: 'private' stamp: 'AdrianLienhard 10/19/2009 12:07'!
cleanUpInstanceVariables
	self class allInstVarNames do: [ :name |
		name = 'testSelector' ifFalse: [
			self instVarNamed: name put: nil ] ]! !

!TestCase methodsFor: 'private' stamp: 'dc 4/2/2007 18:46'!
comparingStringBetween: expected and: actual
	^ String streamContents: [:stream |
		stream
			nextPutAll: 'Expected ';
			nextPutAll: (expected printStringLimitedTo: 10);
			nextPutAll: ' but was ';
			nextPutAll: (actual printStringLimitedTo: 10);
			nextPutAll: '.'
		]! !

!TestCase methodsFor: 'private' stamp: 'md 2/22/2006 14:27'!
executeShould: aBlock inScopeOf: anExceptionalEvent 
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: true]
			! !

!TestCase methodsFor: 'private' stamp: 'md 2/22/2006 14:27'!
executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionContaining: aString
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: (ex description includesSubString: aString) ]
			! !

!TestCase methodsFor: 'private' stamp: 'md 2/22/2006 14:27'!
executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionNotContaining: aString
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: (ex description includesSubString: aString) not ]
			! !

!TestCase methodsFor: 'private' stamp: 'md 2/22/2006 14:22'!
performTest

	self perform: testSelector asSymbol
			! !

!TestCase methodsFor: 'private'!
setTestSelector: aSymbol
	testSelector := aSymbol
			! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

TestCase class
	instanceVariableNames: 'history'!

!TestCase class methodsFor: '*sunitgui' stamp: 'lr 4/12/2009 00:27'!
packageNamesUnderTest
	"Answer a collection of package names under test. This is used by the test runner to automatically instrument the code in these packages when checking for test coverage."
	
	^ #()! !


!TestCase class methodsFor: 'accessing' stamp: 'md 2/22/2006 14:28'!
allTestSelectors

	^self allSelectors asSortedCollection asOrderedCollection select: [:each | 
		('test*' match: each) and: [each numArgs isZero]]
			! !

!TestCase class methodsFor: 'accessing'!
resources

	^#()
			! !

!TestCase class methodsFor: 'accessing'!
sunitVersion
	^'3.1'
			! !

!TestCase class methodsFor: 'accessing' stamp: 'md 2/22/2006 14:29'!
testSelectors 

	^self selectors asSortedCollection asOrderedCollection select: [:each | 
		('test*' match: each) and: [each numArgs isZero]]
			! !


!TestCase class methodsFor: 'building suites' stamp: 'stephaneducasse 2/3/2006 22:41'!
addTestsFor: classNameString toSuite: suite

	| cls  |
	cls := Smalltalk at: classNameString ifAbsent: [ ^suite ].
	^cls isAbstract 
		ifTrue:  [
			cls allSubclasses do: [ :each |
				each isAbstract ifFalse: [
					each addToSuiteFromSelectors: suite ] ].
			suite]
		ifFalse: [ cls addToSuiteFromSelectors: suite ]
! !

!TestCase class methodsFor: 'building suites' stamp: 'nk 4/21/2002 16:37'!
addToSuiteFromSelectors: suite
	^self addToSuite: suite fromMethods: (self shouldInheritSelectors
		ifTrue: [ self allTestSelectors ]
		ifFalse: [self testSelectors ])! !

!TestCase class methodsFor: 'building suites' stamp: 'nk 4/21/2002 10:51'!
addToSuite: suite fromMethods: testMethods 
	testMethods do:  [ :selector | 
			suite addTest: (self selector: selector) ].
	^suite! !

!TestCase class methodsFor: 'building suites' stamp: 'stephaneducasse 2/3/2006 22:41'!
buildSuite
	| suite |
	suite := TestSuite new.
	^ self isAbstract
		ifTrue: [
			suite name: self name asString.
			self allSubclasses
				do: [:each | each isAbstract
						ifFalse: [each addToSuiteFromSelectors: suite]].
			suite]
		ifFalse: [self addToSuiteFromSelectors: suite]! !

!TestCase class methodsFor: 'building suites'!
buildSuiteFromAllSelectors

	^self buildSuiteFromMethods: self allTestSelectors
			! !

!TestCase class methodsFor: 'building suites'!
buildSuiteFromLocalSelectors

	^self buildSuiteFromMethods: self testSelectors
			! !

!TestCase class methodsFor: 'building suites' stamp: 'stephaneducasse 2/3/2006 22:41'!
buildSuiteFromMethods: testMethods 
	| suite |
	suite := (TestSuite new)
				name: self name asString;
				yourself.
	^self addToSuite: suite fromMethods: testMethods! !

!TestCase class methodsFor: 'building suites'!
buildSuiteFromSelectors

	^self shouldInheritSelectors
		ifTrue: [self buildSuiteFromAllSelectors]
		ifFalse: [self buildSuiteFromLocalSelectors]
			! !

!TestCase class methodsFor: 'building suites'!
suiteClass
	^TestSuite
			! !


!TestCase class methodsFor: 'coverage' stamp: 'sd 1/28/2009 14:04'!
coverage
	"returns the coverage determined by a simple static analysis of test coverage 
	made by the receiver on a class that is identified by the name of the receiver.
	We assume that SetTest test Set."
	
	| cls className |
	(self name endsWith: 'Test') ifFalse: [self error: 'Please, use #coverageForClass: instead'].

	className := self name copyFrom: 1 to: (self name size - 'Test' size).
	cls := Smalltalk at: className asSymbol ifAbsent: [self error: 'Please, use #coverageForClass: instead'].
	
	"May happen with Transcript"
	cls isBehavior ifFalse: [cls := cls class].
	
	^ self coverageForClass: cls! !

!TestCase class methodsFor: 'coverage' stamp: 'ab 12/25/2008 17:20'!
coverageAsString
	| cov className |
	cov := self coverage first asInteger. 
	"coverage already checks that the name is ends with 'Test' and if the class tested exists"
	
	className := self name copyFrom: 1 to: (self name size - 'Test' size).
	^ self name asString, ' covers ', cov asString, '% of ', className.! !

!TestCase class methodsFor: 'coverage' stamp: 'sd 1/28/2009 14:57'!
coverageForClass: cls
	"returns the test coverage of all the methods included inherited ones"
	^ self coverageForClass: cls until: ProtoObject! !

!TestCase class methodsFor: 'coverage' stamp: 'sd 1/28/2009 14:58'!
coverageForClass: cls until: aRootClass
	"returns the test coverage of all the methods included inherited ones but stopping at aRootClass included"
	
	| definedMethods testedMethods untestedMethods |
	definedMethods := cls allSelectorsAboveUntil: aRootClass.
	definedMethods size = 0
		ifTrue: [^ {0. Set new}].
	testedMethods := 
		self methodDictionary values inject: Set new into: 
							[:sums :cm | sums union: cm messages].
	testedMethods := testedMethods reject: [:sel | (definedMethods includes: sel) not].
	untestedMethods := definedMethods select: [:selector | (testedMethods includes: selector) not].
	^ { (testedMethods size * 100 / definedMethods size) asFloat . untestedMethods}
! !

!TestCase class methodsFor: 'coverage' stamp: 'ab 12/25/2008 17:15'!
coveragePercentage
	^ self coverage first! !

!TestCase class methodsFor: 'coverage' stamp: 'sd 1/28/2009 15:03'!
localCoverage
	"returns the coverage determined by a simple static analysis of test coverage 
	made by the receiver on a class that is identified by the name of the receiver.
	We assume that SetTest test Set. The computation of the coverage takes only into
	account the methods defined locally in the tested class. See coverage for a more global 
	coverage"
	
	| cls className |
	(self name endsWith: 'Test') ifFalse: [self error: 'Please, use #localCoverageForClass: instead'].
	className := self name copyFrom: 1 to: (self name size - 'Test' size).
	cls := Smalltalk at: className asSymbol ifAbsent: [self error: 'Please, use #localCoverageForClass: instead'].
	cls isBehavior ifFalse: [cls := cls class].
	^ self localCoverageForClass: cls! !

!TestCase class methodsFor: 'coverage' stamp: 'sd 1/28/2009 15:04'!
localCoverageAsString
	| cov className |
	cov := self localCoverage first asInteger. 
	"coverage already checks that the name is ends with 'Test' and if the class tested exists"
	
	className := self name copyFrom: 1 to: (self name size - 'Test' size).
	^ self name asString, ' covers ', cov asString, '% of ', className.! !

!TestCase class methodsFor: 'coverage' stamp: 'sd 1/28/2009 14:55'!
localCoverageForClass: cls
	
	| definedMethods testedMethods untestedMethods |
	definedMethods := cls selectors.
	"It happens for IdentityBag / IdentityBagTest"
	definedMethods size = 0
		ifTrue: [^ {0. Set new}].

	testedMethods := 
		self methodDictionary values inject: Set new into: 
							[:sums :cm | sums union: cm messages].
					
	"testedMethods contains all the methods send in test methods, which probably contains methods that have nothign to do with collection"
	testedMethods := testedMethods reject: [:sel | (definedMethods includes: sel) not].

	untestedMethods := definedMethods select: [:selector | (testedMethods includes: selector) not].

	^ { (testedMethods size * 100 / definedMethods size) asFloat . untestedMethods}
! !

!TestCase class methodsFor: 'coverage' stamp: 'sd 1/28/2009 14:55'!
localCoveragePercentage
	^ self localCoverage first! !


!TestCase class methodsFor: 'history' stamp: 'simon.denier 11/13/2008 19:22'!
generateLastStoredRunMethod

	self shouldGenerateLastStoredRunMethod ifTrue: [
		self class
			compile: (self lastRunMethodNamed: #lastStoredRun)
			classified: 'history' ]! !

!TestCase class methodsFor: 'history' stamp: 'Alexandre.Bergel 4/3/2009 14:57'!
history
	^ history ifNil: [ history := self newTestDictionary ]! !

!TestCase class methodsFor: 'history' stamp: 'Alexandre.Bergel 4/3/2009 14:45'!
history: aDictionary
	history := aDictionary! !

!TestCase class methodsFor: 'history' stamp: 'simon.denier 11/22/2008 20:56'!
lastRun
	^ TestResult historyFor: self! !

!TestCase class methodsFor: 'history' stamp: 'simon.denier 11/13/2008 19:21'!
lastRunMethodNamed: aSelector
	
	^ String streamContents: [:str |
		str nextPutAll: aSelector asString ;cr.
		str tab; nextPutAll: '^ ', (self lastRun) storeString]
! !

!TestCase class methodsFor: 'history' stamp: 'AlexandreBergel 10/22/2008 10:33'!
lastStoredRun
	^ ((Dictionary new) add: (#failures->#()); add: (#passed->#()); add: (#errors->#()); yourself)! !

!TestCase class methodsFor: 'history' stamp: 'Alexandre.Bergel 4/3/2009 14:57'!
newTestDictionary

	^ Dictionary new at: #timeStamp put: TimeStamp now;
		at: #passed put: Set new;
		at: #failures put: Set new;
		at: #errors put: Set new;
		yourself
		! !

!TestCase class methodsFor: 'history' stamp: 'Alexandre.Bergel 4/3/2009 14:47'!
resetHistory
	history := nil! !

!TestCase class methodsFor: 'history' stamp: 'simon.denier 11/13/2008 21:29'!
shouldGenerateLastStoredRunMethod
	| sameRun |
	
	(self class methodDictionary includesKey: #lastStoredRun)
		ifFalse: [^ true].
	sameRun := #(#passed #failures #errors) inject: true into: 
		[ :ok :set | ok and: [(self lastRun at: set) = (self lastStoredRun at: set) ]].
	^ sameRun not
! !


!TestCase class methodsFor: 'initialize - event' stamp: 'AlexandreBergel 10/22/2008 13:31'!
initialize
     super initialize.
	SystemChangeNotifier uniqueInstance notify: self ofSystemChangesOfItem: #method using: #methodChanged:.! !

!TestCase class methodsFor: 'initialize - event' stamp: 'al 2/9/2009 20:00'!
methodChanged: anEvent
	"Remove the changed method from the known test results."
	
	| cls sel |
	anEvent item isCompiledMethod ifFalse: [ ^ self ].
	cls := anEvent item methodClass.
	(cls inheritsFrom: TestCase)
		ifFalse: [^ self].
	sel := anEvent item selector.
	(sel beginsWith: 'test')
		ifFalse: [^ self].
	TestResult removeFromTestHistory: sel in: cls.
! !


!TestCase class methodsFor: 'instance creation'!
debug: aSymbol

	^(self selector: aSymbol) debug
			! !

!TestCase class methodsFor: 'instance creation'!
run: aSymbol

	^(self selector: aSymbol) run
			! !

!TestCase class methodsFor: 'instance creation'!
selector: aSymbol

	^self new setTestSelector: aSymbol
			! !

!TestCase class methodsFor: 'instance creation'!
suite

	^self buildSuite
			! !


!TestCase class methodsFor: 'testing' stamp: 'Alexandre.Bergel 4/3/2009 15:06'!
hasMethodBeenRun: aSelector
	^ ((self lastRun at: #errors),
		(self lastRun at: #failures),
		(self lastRun at: #passed))
			includes: aSelector! !

!TestCase class methodsFor: 'testing' stamp: 'md 2/22/2006 14:21'!
isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self name = #TestCase
			! !

!TestCase class methodsFor: 'testing' stamp: 'AlexandreBergel 10/21/2008 15:58'!
methodFailed: aSelector
	^ (self lastRun at: #failures) includes: aSelector! !

!TestCase class methodsFor: 'testing' stamp: 'AlexandreBergel 10/21/2008 16:00'!
methodPassed: aSelector
	^ (self lastRun at: #passed) includes: aSelector! !

!TestCase class methodsFor: 'testing' stamp: 'AlexandreBergel 10/21/2008 16:00'!
methodProgressed: aSelector
	^ ((self storedMethodRaisedError: aSelector) or: [self storedMethodFailed: aSelector])
		and: [self methodPassed: aSelector]
		! !

!TestCase class methodsFor: 'testing' stamp: 'AlexandreBergel 10/21/2008 16:00'!
methodRaisedError: aSelector
	^ (self lastRun at: #errors) includes: aSelector! !

!TestCase class methodsFor: 'testing' stamp: 'AlexandreBergel 10/21/2008 16:00'!
methodRegressed: aSelector
	^ (self storedMethodPassed: aSelector) and: [(self methodFailed: aSelector) or: [self methodRaisedError: aSelector]]! !

!TestCase class methodsFor: 'testing'!
shouldInheritSelectors
	"I should inherit from an Abstract superclass but not from a concrete one by default, unless I have no testSelectors in which case I must be expecting to inherit them from my superclass.  If a test case with selectors wants to inherit selectors from a concrete superclass, override this to true in that subclass."

	^self superclass isAbstract
		or: [self testSelectors isEmpty]

"$QA Ignore:Sends system method(superclass)$"
			! !

!TestCase class methodsFor: 'testing' stamp: 'AlexandreBergel 10/21/2008 15:59'!
storedMethodFailed: aSelector
	^ (self lastStoredRun at: #failures) includes: aSelector! !

!TestCase class methodsFor: 'testing' stamp: 'AlexandreBergel 10/21/2008 16:00'!
storedMethodPassed: aSelector
	^ (self lastStoredRun at: #passed) includes: aSelector! !

!TestCase class methodsFor: 'testing' stamp: 'AlexandreBergel 10/21/2008 15:59'!
storedMethodRaisedError: aSelector
	^ (self lastStoredRun at: #errors) includes: aSelector! !
