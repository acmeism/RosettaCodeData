#include <iostream>
#include <vector>
#include <forward_list>
#include <cassert>
#include <memory>

template<typename T>
class VList {
public:
    VList() : datas(), offset(0) {}
private:
    std::forward_list<std::shared_ptr<std::vector<T>>> datas;
    int offset;
public:

    // modify structure instead of returning a new one like the pure functional way does
    void cons(const T& a) {
        if(datas.empty()){
            std::shared_ptr<std::vector<T>> base = std::shared_ptr<std::vector<T>>(new std::vector<T>(1)) ;
            (*base)[0] = a;
            datas.emplace_front(base);
            offset = 0;
            return;
        }
        if(offset == 0){
            datas.front()->shrink_to_fit();
            const int new_capacity = (int) datas.front()->capacity() * 2;
            const int new_offset = new_capacity - 1;
            std::shared_ptr<std::vector<T>> base = std::shared_ptr<std::vector<T>>(new std::vector<T>(new_capacity)) ;
            (*base)[new_offset] = a;
            datas.emplace_front(base);
            offset = new_offset;
            return ;
        }
        --offset;
        (* datas.front())[offset] = a;
    }

    // lisp like cdr to keep previous version
    VList* cdr() {
        if (datas.empty()) {
            // cdr of empty list is an empty list
            return this;
        }
        VList* new_vlist = new VList();
        new_vlist->datas = this->datas;
        new_vlist->offset = offset;
        new_vlist->offset++;
        if(new_vlist->offset < new_vlist->datas.front()->capacity()){
            return new_vlist;
        }
        new_vlist->offset = 0;
        new_vlist->datas.front().reset();
        new_vlist->datas.pop_front();
        return new_vlist;
    }

    // compute the length of the list.  (It's O(1).)
    int length() {
        if (datas.empty()) {
            return 0;
        }
        return (int)datas.front()->capacity()*2 - this->offset - 1;
    }

    bool index(int i, T& out) {
        bool isValid = false;
        if (i >= 0) {
            i += this->offset;
            for(auto data : datas) {
                if (i < data->size()) {
                    out = (* data)[i];
                    isValid = true;
                    break;
                }
                i -= data->size();
            }
        }
        return isValid;
    }

    void printList() {
        if (datas.empty()) {
            std::cout << "[]" << std::endl;
            return;
        }
        std::vector<T>* first = datas.front().get();
        assert(NULL != first);
        std::cout << "[";
        for (int i=offset; i<first->size(); i++) {
            std::cout << " " << (* first)[i];
        }
        for(auto data : datas) {
            if(data.get() == datas.front().get())
                continue;
            for (int i=0; i<data->size(); i++) {
                std::cout << " " << (* data)[i];
            }
        }
        std::cout << " ]" << std::endl;
    }

    // One more method for demonstration purposes
    void printStructure() {
        std::cout << "offset:" << this->offset << std::endl;
        if (datas.empty()) {
            std::cout << "[]" << std::endl;
            return ;
        }
        std::vector<T>* first = datas.front().get();
        assert(NULL != first);
        std::cout << "[";
        for (int i=offset; i<first->size(); i++) {
            std::cout << " " << (* first)[i];
        }
        std::cout << " ]" << std::endl;
        for(auto data : datas) {
            if(data.get() == datas.front().get())
                continue;
            std::cout << "[";
            for (int i=0; i<data->size(); i++) {
                std::cout << " " << (* data)[i];
            }
            std::cout << " ]" << std::endl;
        }
        std::cout << std::endl;
    }
};

int main(int argc, const char * argv[]) {

    std::unique_ptr<VList<char>> vlist = std::unique_ptr<VList<char>>(new VList<char>());

    std::cout << "zero value for type.  empty vList:";
    vlist->printList();
    vlist->printStructure();

    std::cout << "demonstrate cons. 6 elements added:";
    for (char a = '6'; a >= '1'; a--) {
        vlist->cons(a);
    }
    vlist->printList();
    vlist->printStructure();

    std::cout << "demonstrate cdr. 1 element removed:";
    vlist = std::unique_ptr<VList<char>>(vlist->cdr());
    vlist->printList();
    vlist->printStructure();

    std::cout << "demonstrate length. length =" << vlist->length() << std::endl;

    char out;
    bool isValid = vlist->index(3, out);
    if(isValid)
        std::cout << "demonstrate element access. v[3] =" << out << std::endl;

    std::cout << "show cdr releasing segment. 2 elements removed:";
    vlist = std::unique_ptr<VList<char>>(vlist->cdr()->cdr());
    vlist->printList();
    vlist->printStructure();

    return 0;
}
