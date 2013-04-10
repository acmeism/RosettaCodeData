#include <iostream>

class CWidget; // Forward-declare that we have a class named CWidget.

class CFactory
{
private:
  unsigned int m_uiCount;
public:
  CFactory();
  ~CFactory();
  CWidget* GetWidget();
};

class CWidget
{
private:
  unsigned int* m_pCounter;

private:
  CWidget(); // Disallow the default constructor.
  CWidget(const CWidget&); // Disallow the copy constructor
  CWidget& operator=(const CWidget&); // Disallow the assignment operator.
public:
  CWidget(unsigned int* pCounter);
  ~CWidget();
};

// CFactory constructors and destructors. Very simple things.
CFactory::CFactory() : m_uiCount(0) {}
CFactory::~CFactory() {}

// CFactory method which creates CWidgets.
CWidget* CFactory::GetWidget()
{
  // Create a new CWidget, tell it we're its parent.
  return new CWidget(&m_uiCount);
}

// CWidget constructor
CWidget::CWidget(unsigned int* pCounter) : m_pCounter(pCounter)
{
  ++*m_pCounter;

  std::cout << "Widget spawning. There are now " << *m_pCounter<< " Widgets instanciated." << std::endl;
}

CWidget::~CWidget()
{
  --*m_pCounter;

  std::cout << "Widget dieing. There are now " << *m_pCounter<< " Widgets instanciated." << std::endl;
}

int main()
{
  CFactory factory;

  CWidget* pWidget1 = factory.GetWidget();
  CWidget* pWidget2 = factory.GetWidget();
  delete pWidget1;

  CWidget* pWidget3 = factory.GetWidget();
  delete pWidget3;
  delete pWidget2;
}
