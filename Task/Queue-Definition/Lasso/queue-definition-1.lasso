define myqueue => type {
    data store = list

    public onCreate(...) => {
        if(void != #rest) => {
            with item in #rest do .`store`->insert(#item)
        }
    }

    public push(value) => .`store`->insertLast(#value)

    public pop => {
        handle => {
            .`store`->removefirst
        }

        return .`store`->first
    }

    public isEmpty => (.`store`->size == 0)
}
