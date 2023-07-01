#include <iostream>
#include <vector>
#include <random>
#include <memory>
#include <cassert>

using namespace std;

struct Fork {
    static const int ON_TABLE = -1;
    int holder = ON_TABLE;
    int request = ON_TABLE;
    int id;
    bool dirty = true;
    Fork(int id) {
        this->id = id;
    }
    bool isRequest() {
        return request != Fork::ON_TABLE;
    }

    void process(int &forkCount, int &dirtyCount) {
        if (holder == id) {
            forkCount++;
            if (isRequest()) {
                if (dirty) {
                    forkCount--;
                    dirty = false;
                    holder = request;
                }
                request = Fork::ON_TABLE;
            }
        }
        else
        if (holder == Fork::ON_TABLE) {
            holder = id;
            forkCount++;
            assert(dirty);
            dirtyCount++;
            assert(request == Fork::ON_TABLE);
        } else {
            request = id;
        }
    }
};

class Table;

enum State { Have0Forks, Have1Fork,Have01Fork, Have2Forks, Eat, AfterEat, Pon };

class Philosopher {
    int id;
    Table *table;
public:
    Fork* left;
    Fork* right;
    int eatStarts = 0;
    Philosopher(Table *table, int id);
    void naive();
    void ChandyMisra();
    State state;

    void selectState(int forkCount, int dirtyCount);
};

class Table {
    mt19937 mt_rand;
    std::uniform_real_distribution<> dis;
    unique_ptr<std::uniform_int_distribution<>> disint;
public:
    static const int PhilCount = 5;
    vector<unique_ptr<Philosopher>> philosophers;
    vector<unique_ptr<Fork>> forks;
    Table() {
        mt_rand.seed(1234);
        disint = make_unique<std::uniform_int_distribution<>>(0, PhilCount-1);
        for (int i=0; i<PhilCount; i++)
            forks.push_back(make_unique<Fork>(i));
        for (int i=0; i<PhilCount; i++)
            philosophers.push_back(make_unique<Philosopher>(this, i));
    }
    double rand() {
        return dis(mt_rand);
    }

    double randInt() {
        return (*disint)(mt_rand);
    }
    void naive() {
        cout << "Naive algorithm" << endl;
        for (int i=0; i<Table::PhilCount; i++)
            philosophers[i]->state = State::Have0Forks;
        for (int i=0; i<100000; i++) {
            philosophers[randInt()]->naive();
        }
        for (int i=0; i<Table::PhilCount; i++)
            cout << i << " : " << philosophers[i]->eatStarts << endl;
    }
    void ChandyMisra() {
        cout << "Chandy-Misra algorithm" << endl;
        for (int i=0; i<Table::PhilCount; i++) {
            philosophers[i]->state = State::Have01Fork;
            philosophers[i]->eatStarts = 0;
            philosophers[i]->left->holder = i;
        }
        for (int i=0; i<100000; i++) {
            philosophers[randInt()]->ChandyMisra();
        }
        for (int i=0; i<Table::PhilCount; i++)
            cout << i << " : " << philosophers[i]->eatStarts << endl;
    }
};

Philosopher::Philosopher(Table *table, int id):table(table), id(id) {
    left = table->forks[id].get();
    right = table->forks[(id+1) % Table::PhilCount].get();
}

void Philosopher::naive() {
    switch (state) {
        case State::Pon:
            if (table->rand()<0.2)
                state = State::Have0Forks;
            return;
        case State::Have0Forks:
            int forkCount;
            forkCount = 0;
            if (left->holder==Fork::ON_TABLE) {
                left->holder=id;
                forkCount++;
            }
            if (right->holder==Fork::ON_TABLE) {
                right->holder=id;
                forkCount++;
            }
            if (forkCount==1)
                state = State::Have1Fork;
            else if (forkCount==2)
                state = State::Have2Forks;
            return;
        case State::Have1Fork:
            Fork* forkToWait;
            if (left->holder==id)
                forkToWait = right;
            else
                forkToWait = left;
            if (forkToWait->holder==Fork::ON_TABLE) {
                forkToWait->holder=id;
                state = State::Have2Forks;
            }
            return;
        case State::Have2Forks:
            state = State::Eat;
            eatStarts++;
            return;
        case State::Eat:
            if (table->rand()<0.2)
                state = State::AfterEat;
            return;
        case State::AfterEat:
            left->holder = Fork::ON_TABLE;
            right->holder = Fork::ON_TABLE;
            state = State::Pon;
            return;
    }
}

void Philosopher::ChandyMisra() {
    switch (state) {
        case State::Pon:
            if (table->rand() < 0.2)
                state = State::Have01Fork;
            return;
        case State::Have01Fork:
            int forkCount;
            int dirtyCount;
            forkCount = 0;
            dirtyCount = 0;
            left->process(forkCount, dirtyCount);
            right->process(forkCount, dirtyCount);
            selectState(forkCount, dirtyCount);
            return;
        case State::Have2Forks:
            state = State::Eat;
            eatStarts++;
            return;
        case State::Eat:
            if (table->rand()<0.2)
                state = State::AfterEat;
            return;
        case State::AfterEat:
            if (left->request!=Fork::ON_TABLE) {
                left->dirty = false;
                left->holder = left->request;
                left->request = Fork::ON_TABLE;
            } else {
                left->holder = Fork::ON_TABLE;
                left->dirty = true;
            }

            if (right->request!=Fork::ON_TABLE) {
                right->dirty = false;
                right->holder = right->request;
                right->request = Fork::ON_TABLE;
            } else {
                right->holder = Fork::ON_TABLE;
                right->dirty = true;
            }
            state = State::Pon;
            return;
    }
}

void Philosopher::selectState(int forkCount, int dirtyCount) {
    if (forkCount == 2 && dirtyCount==0)
        state = State::Have2Forks;
    else
        state = State::Have01Fork;
}

int main() {
    Table table;
    table.naive();
    table.ChandyMisra();
    return 0;
}
