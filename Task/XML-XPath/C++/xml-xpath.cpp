#include <cassert>
#include <cstdlib>
#include <iostream>
#include <stdexcept>
#include <utility>
#include <vector>

#include <libxml/parser.h>
#include <libxml/tree.h>
#include <libxml/xmlerror.h>
#include <libxml/xmlstring.h>
#include <libxml/xmlversion.h>
#include <libxml/xpath.h>

#ifndef LIBXML_XPATH_ENABLED
#   error libxml was not configured with XPath support
#endif

// Because libxml2 is a C library, we need a couple things to make it work
// well with modern C++:
//   1) a ScopeGuard-like type to handle cleanup functions; and
//   2) an exception type that transforms the library's errors.

// ScopeGuard-like type to handle C library cleanup functions.
template <typename F>
class [[nodiscard]] scope_exit
{
public:
    // C++20: Constructor can (and should) be [[nodiscard]].
    /*[[nodiscard]]*/ constexpr explicit scope_exit(F&& f) :
        f_{std::move(f)}
    {}

    ~scope_exit()
    {
        f_();
    }

    // Non-copyable, non-movable.
    scope_exit(scope_exit const&) = delete;
    scope_exit(scope_exit&&) = delete;
    auto operator=(scope_exit const&) -> scope_exit& = delete;
    auto operator=(scope_exit&&) -> scope_exit& = delete;

private:
    F f_;
};

// Exception that gets last libxml2 error.
class libxml_error : public std::runtime_error
{
public:
    libxml_error() : libxml_error(std::string{}) {}

    explicit libxml_error(std::string message) :
        std::runtime_error{make_message_(std::move(message))}
    {}

private:
    static auto make_message_(std::string message) -> std::string
    {
        if (auto const last_error = ::xmlGetLastError(); last_error)
        {
            if (not message.empty())
                message += ": ";
            message += last_error->message;
        }

        return message;
    }
};

auto main() -> int
{
    try
    {
        // Initialize libxml.
        ::xmlInitParser();
        LIBXML_TEST_VERSION
        auto const libxml_cleanup = scope_exit{[] { ::xmlCleanupParser(); }};

        // Load and parse XML document.
        auto const doc = ::xmlParseFile("test.xml");
        if (not doc)
            throw libxml_error{"failed to load document"};
        auto const doc_cleanup = scope_exit{[doc] { ::xmlFreeDoc(doc); }};

        // Create XPath context for document.
        auto const xpath_context = ::xmlXPathNewContext(doc);
        if (not xpath_context)
            throw libxml_error{"failed to create XPath context"};
        auto const xpath_context_cleanup = scope_exit{[xpath_context]
            { ::xmlXPathFreeContext(xpath_context); }};

        // Task 1 ============================================================
        {
            std::cout << "Task 1:\n";

            auto const xpath =
                reinterpret_cast<::xmlChar const*>(u8"//item[1]");

            // Create XPath object (same for every task).
            auto xpath_obj = ::xmlXPathEvalExpression(xpath, xpath_context);
            if (not xpath_obj)
                throw libxml_error{"failed to evaluate XPath"};
            auto const xpath_obj_cleanup = scope_exit{[xpath_obj]
                { ::xmlXPathFreeObject(xpath_obj); }};

            // 'result' a xmlNode* to the desired node, or nullptr if it
            // doesn't exist. If not nullptr, the node is owned by 'doc'.
            auto const result = xmlXPathNodeSetItem(xpath_obj->nodesetval, 0);
            if (result)
                std::cout << '\t' << "node found" << '\n';
            else
                std::cout << '\t' << "node not found" << '\n';
        }

        // Task 2 ============================================================
        {
            std::cout << "Task 2:\n";

            auto const xpath =
                reinterpret_cast<::xmlChar const*>(u8"//price/text()");

            // Create XPath object (same for every task).
            auto xpath_obj = ::xmlXPathEvalExpression(xpath, xpath_context);
            if (not xpath_obj)
                throw libxml_error{"failed to evaluate XPath"};
            auto const xpath_obj_cleanup = scope_exit{[xpath_obj]
                { ::xmlXPathFreeObject(xpath_obj); }};

            // Printing the results.
            auto const count =
                xmlXPathNodeSetGetLength(xpath_obj->nodesetval);
            for (auto i = decltype(count){0}; i < count; ++i)
            {
                auto const node =
                    xmlXPathNodeSetItem(xpath_obj->nodesetval, i);
                assert(node);

                auto const content = XML_GET_CONTENT(node);
                assert(content);

                // Note that reinterpret_cast here is a Bad Idea, because
                // 'content' is UTF-8 encoded, which may or may not be the
                // encoding cout expects. A *PROPER* solution would translate
                // content to the correct encoding (or at least verify that
                // UTF-8 *is* the correct encoding).
                //
                // But this "works" well enough for illustration.
                std::cout << "\n\t" << reinterpret_cast<char const*>(content);
            }

            std::cout << '\n';
        }

        // Task 3 ============================================================
        {
            std::cout << "Task 3:\n";

            auto const xpath =
                reinterpret_cast<::xmlChar const*>(u8"//name");

            // Create XPath object (same for every task).
            auto xpath_obj = ::xmlXPathEvalExpression(xpath, xpath_context);
            if (not xpath_obj)
                throw libxml_error{"failed to evaluate XPath"};
            auto const xpath_obj_cleanup = scope_exit{[xpath_obj]
                { ::xmlXPathFreeObject(xpath_obj); }};

            // 'results' is a vector of pointers to the result nodes. The
            // nodes pointed to are owned by 'doc'.
            auto const results = [ns=xpath_obj->nodesetval]()
            {
                auto v = std::vector<::xmlNode*>{};
                if (ns && ns->nodeTab)
                    v.assign(ns->nodeTab, ns->nodeTab + ns->nodeNr);
                return v;
            }();
            std::cout << '\t' << "set of " << results.size()
                << " node(s) found" << '\n';
        }
    }
    catch (std::exception const& x)
    {
        std::cerr << "ERROR: " << x.what() << '\n';
        return EXIT_FAILURE;
    }
}
