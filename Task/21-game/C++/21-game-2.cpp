/**
 *  Game 21 - an example in C++ language for Rosseta Code.
 *
 *  This version is an example of MVP architecture. The user input, as well as
 *  the AI opponent, is handled by separate passive subclasses of abstract class
 *  named Controller. It can be noticed that the architecture support OCP,
 *  for an example the AI module can be "easily" replaced by another AI etc.
 *
 *  BTW, it would be better to place each class in its own file. But it would
 *  be less convinient for Rosseta Code, where "one solution" mean "one file".
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
protected:

    int oldTotal;
    int newTotal;
    int lastMove;

public:

    static const int GOAL = 21;
    static const int NUMBER_OF_PLAYERS = 2;

    Model()
    {
        newTotal = 0;
        oldTotal = 0;
        lastMove = 0;
    }

    void update(int move)
    {
        oldTotal = newTotal;
        newTotal = oldTotal + move;
        lastMove = move;
    }

    int getOldTotal()
    {
        return oldTotal;
    }

    int getNewTotal()
    {
        return newTotal;
    }

    int getLastMove()
    {
        return lastMove;
    }

    bool isEndGame()
    {
        return newTotal == GOAL;
    }
};


class View
{
public:

    void update(string comment, Model* model)
    {
        cout << setw(8) << comment << ": "
            << model->getNewTotal()
            << " = "
            << model->getOldTotal()
            << " + "
            << model->getLastMove() << endl
            << endl;
    }

    void newGame(string player)
    {
        cout << _("----NEW GAME----") << endl
            << endl
            << _("The running total is currently zero.") << endl
            << endl
            << _("The first move is ") << player << _(" move.") << endl
            << endl;
    }

    void endGame(string name)
    {
        cout << endl << _("The winner is ") << name << _(".") << endl
            << endl
            << endl;
    }
};


class Controller
{
public:

    virtual string getName() = 0;
    virtual int getMove(Model* model) = 0;
};


class AI : public Controller
{
public:

    string getName()
    {
        return _("AI");
    }

    int getMove(Model* model)
    {
        int n = model->getNewTotal();
        for (int i = 1; i <= 3; i++)
            if (n + i == Model::GOAL)
                return i;
        for (int i = 1; i <= 3; i++)
            if ((n + i - 1) % 4 == 0)
                return i;
        return 1 + rand() % 3;
    }
};


class Human : public Controller
{
public:

    string getName()
    {
        return _("human");
    }

    int getMove(Model* model)
    {
        int n = model->getNewTotal();
        int value;
        while (true) {
            if (n == Model::GOAL - 1)
                cout << _("enter 1 to play (or enter 0 to exit game): ");
            else if (n == Model::GOAL - 2)
                cout << _("enter 1 or 2 to play (or enter 0 to exit game): ");
            else
                cout << _("enter 1 or 2 or 3 to play (or enter 0 to exit game): ");
            cin >> value;
            if (!cin.fail()) {
                if (value == 0)
                    exit(0);
                else if (value >= 1 && value <= 3 && n + value <= Model::GOAL)
                {
                    cout << endl;
                    return value;
                }
            }
            cout << _("Your answer is not a valid choice.") << endl;
            cin.clear();
            cin.ignore((streamsize)numeric_limits<int>::max, '\n');
        }
    }
};


class Presenter
{
protected:

    Model* model;
    View* view;
    Controller** controllers;

public:

    Presenter(Model* model, View* view, Controller** controllers)
    {
        this->model = model;
        this->view = view;
        this->controllers = controllers;
    }

    void run()
    {
        int player = rand() % Model::NUMBER_OF_PLAYERS;
        view->newGame(controllers[player]->getName());

        while (true)
        {
            Controller* controller = controllers[player];
            model->update(controller->getMove(model));
            view->update(controller->getName(), model);
            if (model->isEndGame())
            {
                view->endGame(controllers[player]->getName());
                break;
            }
            player = (player + 1) % Model::NUMBER_OF_PLAYERS;
        }
    }
};


int main(int argc, char* argv)
{
    srand(time(NULL));

    while (true)
    {
        Model* model = new Model();
        View* view = new View();
        Controller* controllers[Model::NUMBER_OF_PLAYERS];
        controllers[0] = new Human();
        for (int i = 1; i < Model::NUMBER_OF_PLAYERS; i++)
            controllers[i] = new AI();
        Presenter* presenter = new Presenter(model, view, controllers);

        presenter->run();

        delete model;
        delete view;
        delete controllers[0];
        delete controllers[1];
        delete presenter;
    }
    return EXIT_SUCCESS; // dead code
}
