#include <cassert>
#include <cstdlib>
#include <iostream>
#include <stdexcept>
#include <utility>
#include <vector>

#include <libxml/parser.h>
#include <libxml/tree.h>
#include <libxml/xmlerror.h>
#include <libxml/xmlsave.h>
#include <libxml/xmlstring.h>
#include <libxml/xmlversion.h>

#ifndef LIBXML_TREE_ENABLED
#   error libxml was not configured with DOM tree support
#endif

#ifndef LIBXML_OUTPUT_ENABLED
#   error libxml was not configured with serialization support
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

auto add_text(::xmlNode* node, ::xmlChar const* content)
{
    // Create a new text node with the desired content.
    auto const text_node = ::xmlNewText(content);
    if (not text_node)
        throw libxml_error{"failed to create text node"};

    // Try to add it to the node. If it succeeds, that node will take
    // ownership of the text node. If it fails, we have to clean up the text
    // node ourselves first, then we can throw.
    if (auto const res = ::xmlAddChild(node, text_node); not res)
    {
        ::xmlFreeNode(text_node);
        throw libxml_error{"failed to add text node"};
    }

    return text_node;
}

auto main() -> int
{
    // Set this to true if you don't want the XML declaration.
    constexpr auto no_xml_declaration = false;

    try
    {
        // Initialize libxml.
        ::xmlInitParser();
        LIBXML_TEST_VERSION
        auto const libxml_cleanup = scope_exit{[] { ::xmlCleanupParser(); }};

        // Create a new document.
        auto doc = ::xmlNewDoc(reinterpret_cast<::xmlChar const*>(u8"1.0"));
        if (not doc)
            throw libxml_error{"failed to create document"};
        auto const doc_cleanup = scope_exit{[doc] { ::xmlFreeDoc(doc); }};

        // Create the root element.
        auto root = ::xmlNewNode(nullptr,
            reinterpret_cast<::xmlChar const*>(u8"root"));
        if (not root)
            throw libxml_error{"failed to create root element"};
        ::xmlDocSetRootElement(doc, root); // doc now owns root

        // Add whitespace. Unless you know the whitespace is not significant,
        // you should do this manually, rather than relying on automatic
        // indenting.
        add_text(root, reinterpret_cast<::xmlChar const*>(u8"\n    "));

        // Add the child element.
        if (auto const res = ::xmlNewTextChild(root, nullptr,
                reinterpret_cast<::xmlChar const*>(u8"element"),
                reinterpret_cast<::xmlChar const*>(
                    u8"\n        Some text here\n    "));
                not res)
            throw libxml_error{"failed to create child text element"};

        // Add whitespace.
        add_text(root, reinterpret_cast<::xmlChar const*>(u8"\n"));

        // Output tree. Note that the output is UTF-8 in all cases. If you
        // want something different, use xmlSaveFileEnc() or the second
        // argument of xmlSaveDoc().
        if constexpr (no_xml_declaration)
        {
            auto const save_context = ::xmlSaveToFilename("-", nullptr,
                XML_SAVE_NO_DECL);
            auto const save_context_cleanup = scope_exit{[save_context] {
                ::xmlSaveClose(save_context); }};

            if (auto const res = ::xmlSaveDoc(save_context, doc); res == -1)
                throw libxml_error{"failed to write tree to stdout"};
        }
        else
        {
            if (auto const res = ::xmlSaveFile("-", doc); res == -1)
                throw libxml_error{"failed to write tree to stdout"};
        }
    }
    catch (std::exception const& x)
    {
        std::cerr << "ERROR: " << x.what() << '\n';
        return EXIT_FAILURE;
    }
}
