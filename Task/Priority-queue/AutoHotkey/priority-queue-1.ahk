;-----------------------------------
PQ_TopItem(Queue,Task:=""){					; remove and return top priority item
	TopPriority := PQ_TopPriority(Queue)
	for T, P in Queue
		if (P = TopPriority) && ((T=Task)||!Task)
			return T , Queue.Remove(T)
	return 0
}
;-----------------------------------
PQ_AddTask(Queue,Task,Priority){				; insert and return new task
	for T, P in Queue
		if (T=Task) || !(Priority && Task)
			return 0
	return Task,	Queue[Task] := Priority
}
;-----------------------------------
PQ_DelTask(Queue, Task){					; delete and return task
	for T, P in Queue
		if (T = Task)
			return Task,	Queue.Remove(Task)
}
;-----------------------------------
PQ_Peek(Queue){							; peek and return top priority task(s)
	TopPriority := PQ_TopPriority(Queue)
	for T, P in Queue
		if (P = TopPriority)
			PeekList .= (PeekList?"`n":"") "`t" T
	return PeekList
}
;-----------------------------------
PQ_Check(Queue,Task){						; check task and return its priority
	for T, P in Queue
		if (T = Task)
			return P
	return 0
}
;-----------------------------------
PQ_Edit(Queue,Task,Priority){					; Update task priority and return its new priority
	for T, P in Queue
		if (T = Task)
			return Priority,	Queue[T]:=Priority
	return 0
}
;-----------------------------------
PQ_View(Queue){							; view current Queue
	for T, P in Queue
		Res .= P " : " T "`n"
	Sort, Res, FMySort
	return "Priority Queue=`n" Res
}
MySort(a,b){
	RegExMatch(a,"(\d+) : (.*)", x), RegExMatch(b,"(\d+) : (.*)", y)
	return x1>y1?1:x1<y1?-1: x2>y2?1:x2<y2?-1: 0
}
;-----------------------------------
PQ_TopPriority(Queue){						; return queue's top priority
	for T, P in Queue
		TopPriority := TopPriority?TopPriority:P	, TopPriority := TopPriority<P?TopPriority:P
	return, TopPriority
}
