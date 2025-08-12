class CFactory {
  constructor() {
    this.m_uiCount = 0;
  }

  // Destructor equivalent - not needed in JS due to garbage collection
  // but included for completeness
  destroy() {
    // Could perform cleanup here if needed
  }

  getWidget() {
    // Create a new CWidget, tell it we're its parent
    return new CWidget(this);
  }
}

class CWidget {
  constructor(parent) {
    if (!parent || !(parent instanceof CFactory)) {
      throw new Error("CWidget requires a CFactory parent");
    }

    this.m_parent = parent;
    ++this.m_parent.m_uiCount;

    console.log(`Widget spawning. There are now ${this.m_parent.m_uiCount} Widgets instantiated.`);
  }

  // Destructor equivalent
  destroy() {
    --this.m_parent.m_uiCount;
    console.log(`Widget dying. There are now ${this.m_parent.m_uiCount} Widgets instantiated.`);
  }
}

// Main function equivalent
function main() {
  const factory = new CFactory();

  const pWidget1 = factory.getWidget();
  const pWidget2 = factory.getWidget();
  pWidget1.destroy(); // Equivalent to delete pWidget1

  const pWidget3 = factory.getWidget();
  pWidget3.destroy(); // Equivalent to delete pWidget3
  pWidget2.destroy(); // Equivalent to delete pWidget2

  // Optional: cleanup factory
  factory.destroy();
}

// Run the main function
main();
