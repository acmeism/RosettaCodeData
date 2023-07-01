/**
 *  Game 21 - an example in C++ language for Rosseta Code.
 *
 *  This version is an example of MVC architecture. It seems be a little cleaner
 *  than MVP. The friendship has broken encapsulations to avoid getters.
 */

#include <cstdlib>
#include <ctime>
#include <iostream>
#include <iomanip>
#include <limits>

using namespace std;
#define _(STR) STR


class Model
{
public:
    static const int GOAL = 21;
    static const int NUMBER_OF_PLAYERS = 2;
    static const int MIN_MOVE = 1;
    static const int MAX_MOVE = 3;
    int bestMove();
    bool update(const char* player, int move);
    bool isGameBegin();
    bool isGameOver();
protected:
    friend class View;
    View* view = nullptr;
    const char* player = nullptr;
    int oldTotal = 0;
    int newTotal = 0;
    int lastMove = 0;
};


class View
{
protected:
    Model* model;
public:
    View(Model* model);
    void init(const char* player);
    void update();
};


class Controller
{
protected:
    Model* model;
    View* view;
public:
    Controller(Model* model, View* view);
    int input();
    void clear();
    void run();
};


int Model::bestMove()
{
    // This is not the fastest algorithm. There is possible to precompute
    // and memorize all answers before game begin or even hard code them.

    int move = MIN_MOVE;
    for (int i = MIN_MOVE; i <= MAX_MOVE; i++)
        if ((newTotal + i - 1) % (MAX_MOVE + 1) == 0)
            move = i;
    for (int i = MIN_MOVE; i <= MAX_MOVE; i++)
        if (newTotal + i == GOAL)
            move = i;
    return move;
}

bool Model::update(const char* player, int move)
{
    if (move >= MIN_MOVE && move <= MAX_MOVE && newTotal + move <= GOAL)
    {
        this->player = player;
        oldTotal = newTotal;
        newTotal = oldTotal + move;
        lastMove = move;
        view->update();
        return true;
    }
    else
        return false;
}

bool Model::isGameBegin()
{
    return oldTotal == 0;
}

bool Model::isGameOver()
{
    return newTotal == GOAL;
}


View::View(Model* model)
{
    this->model = model;
    model->view = this;
}

void View::init(const char* player)
{
    if (model->newTotal == 0)
        cout << _("----NEW GAME----\n\n")
             << _("The running total is currently zero.\n")
             << _("The first move is ") << player << _(" move.\n\n");
}

void View::update()
{
    cout << setw(8) << model->player << ": " << model->newTotal << " = "
         << model->oldTotal << " + " << model->lastMove << endl << endl;
    if (model->isGameOver())
        cout << endl << _("The winner is ") << model->player << _(".\n\n\n");
}


Controller::Controller(Model* model, View* view)
{
    this->model = model;
    this->view = view;
}

void Controller::run()
{
    if (rand() % Model::NUMBER_OF_PLAYERS == 0)
    {
        view->init("AI");
        model->update("AI", model->bestMove());
    }
    else
        view->init("human");

    while (!model->isGameOver())
    {
        while (!model->update("human", input()))
            clear();
        model->update("AI", model->bestMove());
    }
}

int Controller::input()
{
    int value;
    cout << _("enter a valid number to play (or enter 0 to exit game): ");
    cin >> value;
    cout << endl;
    if (!cin.fail())
    {
        if (value == 0)
            exit(EXIT_SUCCESS);
        else
            return value;
    }
    else
        return model->MIN_MOVE - 1;
}

void Controller::clear()
{
    cout << _("Your answer is not a valid choice.") << endl;
    cin.clear();
    cin.ignore((streamsize)numeric_limits<int>::max, '\n');
}


int main(int argc, char* argv)
{
    srand(time(NULL));

    cout << _(
        "21 Game                                                          \n"
        "                                                                 \n"
        "21 is a two player game, the game is played by choosing a number \n"
        "(1, 2, or 3) to be added to the running total. The game is won by\n"
        "the player whose chosen number causes the running total to reach \n"
        "exactly 21. The running total starts at zero.                    \n\n");

    while (true)
    {
        Model* model = new Model();
        View* view = new View(model);
        Controller* controler = new  Controller(model, view);

        controler->run();

        delete controler;
        delete model;
        delete view;
    }
    return EXIT_SUCCESS; // dead code
}
