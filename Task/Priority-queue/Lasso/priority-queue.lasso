define priorityQueue => type {
    data
        store        = map,
        cur_priority = void

    public push(priority::integer, value) => {
        local(store) = .`store`->find(#priority)

        if(#store->isA(::array)) => {
            #store->insert(#value)
            return
        }
        .`store`->insert(#priority=array(#value))

        .`cur_priority`->isA(::void) or #priority < .`cur_priority`
            ? .`cur_priority` = #priority
    }

    public pop => {
        .`cur_priority` == void
            ? return void

        local(store)  = .`store`->find(.`cur_priority`)
        local(retVal) =  #store->first

        #store->removeFirst&size > 0
            ? return #retVal

        // Need to find next priority
        .`store`->remove(.`cur_priority`)

        if(.`store`->size == 0) => {
            .`cur_priority` = void
        else
            // There are better / faster ways to do this
            // The keys are actually already sorted, but the order of
            // storage in a map is not actually defined, can't rely on it
            .`cur_priority` = .`store`->keys->asArray->sort&first
        }

        return #retVal
    }

    public isEmpty => (.`store`->size == 0)

}

local(test) = priorityQueue

#test->push(2,`e`)
#test->push(1,`H`)
#test->push(5,`o`)
#test->push(2,`l`)
#test->push(5,`!`)
#test->push(4,`l`)

while(not #test->isEmpty) => {
    stdout(#test->pop)
}
