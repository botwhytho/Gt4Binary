Class {
	#name : #EBPFProbe,
	#superclass : #Object,
	#instVars : [
		'binary',
		'function',
		'process'
	],
	#category : #Gt4Binary
}

{ #category : #accessing }
EBPFProbe >> binary [
	^ binary
]

{ #category : #accessing }
EBPFProbe >> binary: anObject [
	binary := anObject
]

{ #category : #view }
EBPFProbe >> disable [
	| pipePasswordToStdin processKiller |
	pipePasswordToStdin := [ :aProcess | 
		aProcess stdin
			nextPutAll: (OSEnvironment current at: 'PASSWORD');
			close ].
	processKiller := GtExternalProcessBuilder new
			pipeStdin;
			command: '/usr/bin/sudo';
			args: {'-p'.
					'""'.
					'-S'.
					'kill'.
					self process id asString};
			spawn.
	pipePasswordToStdin value: processKiller.
	processKiller waitWithOutput.
	1 second wait.
	self process terminate
]

{ #category : #view }
EBPFProbe >> enable [
	| generateUProbe |
	generateUProbe := [ :aFile :aFunction | 
		GtExternalProcessBuilder new
			workingDirectory: '.';
			command: '/usr/bin/bash';
			args: {'-c'.
					'trap ''echo signal received!; printf "%s" "${PASSWORD}" | sudo -p "" -S kill -SIGKILL $child_pid'' SIGTERM
printf "%s" "${PASSWORD}" |  sudo -p "" -S bpftrace -e ''uprobe:'
						, aFile asFileReference pathString , ':' , aFunction
						, ' {
printf("%s\n", ustack());
}'' -f json -o bpf.trace &

sudo_pid=$!
sleep 1
child_pid=$(ps --ppid $sudo_pid -o pid= | tr -d ''\n'')
wait $sudo_pid
'};
			withOSLineEndings ].
	self process: (generateUProbe value: self binary path value: self function) spawn
]

{ #category : #accessing }
EBPFProbe >> function [
	^ function
]

{ #category : #accessing }
EBPFProbe >> function: anObject [
	function := anObject
]

{ #category : #view }
EBPFProbe >> gtProbeEventsFor: aView [
	<gtView>
	^ aView forward
		title: 'Events';
		priority: 1;
		object: 'bpf.trace' asFileReference;
		view: #gtContentsFor:
]

{ #category : #accessing }
EBPFProbe >> process [
	^ process
]

{ #category : #accessing }
EBPFProbe >> process: anObject [
	process := anObject
]
