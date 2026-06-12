#include <iostream>
#include <unordered_map>
#include <mutex>
#include <memory>

enum class MultitonType {
    ZERO,
    ONE,
    TWO
};

class Multiton {
public:
    // Thread-safe method to get instance
    // Returns nullptr if the type is not found in the map
    static Multiton* getInstance(MultitonType type) {
        std::lock_guard<std::mutex> lock(mutex_);
        auto it = instances_.find(type);
        return (it != instances_.end()) ? it->second.get() : nullptr;
    }

    // Override toString equivalent
    std::string toString() const {
        std::string typeStr;
        switch (type_) {
            case MultitonType::ZERO: typeStr = "ZERO"; break;
            case MultitonType::ONE:  typeStr = "ONE";  break;
            case MultitonType::TWO:  typeStr = "TWO";  break;
        }
        return "This is Multiton " + typeStr;
    }

    // Overload << operator for easy printing
    friend std::ostream& operator<<(std::ostream& os, const Multiton& multiton) {
        os << multiton.toString();
        return os;
    }

private:
    // Private constructor to prevent direct instantiation
    explicit Multiton(MultitonType type) : type_(type) {}

    MultitonType type_;

    // Thread-safe static members
    static std::unordered_map<MultitonType, std::unique_ptr<Multiton>> instances_;
    static std::mutex mutex_;

    // Static initialization helper
    static bool initializeInstances();
    static bool initialized_;
};

// Static member definitions
std::unordered_map<MultitonType, std::unique_ptr<Multiton>> Multiton::instances_;
std::mutex Multiton::mutex_;
bool Multiton::initialized_ = Multiton::initializeInstances();

// Initialize all instances (equivalent to Java's static block)
bool Multiton::initializeInstances() {
    instances_[MultitonType::ZERO] = std::unique_ptr<Multiton>(new Multiton(MultitonType::ZERO));
    instances_[MultitonType::ONE]  = std::unique_ptr<Multiton>(new Multiton(MultitonType::ONE));
    instances_[MultitonType::TWO]  = std::unique_ptr<Multiton>(new Multiton(MultitonType::TWO));
    return true;
}

int main() {
    Multiton* alpha = Multiton::getInstance(MultitonType::ZERO);
    Multiton* beta  = Multiton::getInstance(MultitonType::ZERO);
    Multiton* gamma = Multiton::getInstance(MultitonType::ONE);
    Multiton* delta = Multiton::getInstance(MultitonType::TWO);

    std::cout << *alpha << std::endl;
    std::cout << *beta << std::endl;
    std::cout << *gamma << std::endl;
    std::cout << *delta << std::endl;

    // Verify that alpha and beta point to the same instance
    std::cout << "alpha == beta: " << (alpha == beta ? "true" : "false") << std::endl;

    return 0;
}
