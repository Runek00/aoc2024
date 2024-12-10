function createQueue()
	return { front = 1, rear = 0 }
end

function isEmpty(q)
	return q.front > q.rear
end

function enqueue(q, item)
	q.rear = q.rear + 1
	q[q.rear] = item
end

function dequeue(q)
	if not isEmpty(q) then
		local item = q[q.front]
		q[q.front] = nil
		q.front = q.front + 1
		return item
	end
end

function front(q)
	if not isEmpty(q) then
		return q[q.front]
	end
end

function size(q)
	return q.rear - q.front + 1
end

local Q = {
	createQueue = createQueue,
	isEmpty = isEmpty,
	enqueue = enqueue,
	dequeue = dequeue,
	front = front,
	size = size,
}

return Q
