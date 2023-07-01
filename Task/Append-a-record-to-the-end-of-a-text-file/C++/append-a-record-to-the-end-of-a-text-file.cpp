#include <iostream>
#include <fstream>
#include <string>
#include <vector>

std::ostream& operator<<(std::ostream& out, const std::string s) {
    return out << s.c_str();
}

struct gecos_t {
    std::string fullname, office, extension, homephone, email;

    friend std::ostream& operator<<(std::ostream&, const gecos_t&);
};

std::ostream& operator<<(std::ostream& out, const gecos_t& g) {
    return out << g.fullname << ',' << g.office << ',' << g.extension << ',' << g.homephone << ',' << g.email;
}

struct passwd_t {
    std::string account, password;
    int uid, gid;
    gecos_t gecos;
    std::string directory, shell;

    passwd_t(const std::string& a, const std::string& p, int u, int g, const gecos_t& ge, const std::string& d, const std::string& s)
        : account(a), password(p), uid(u), gid(g), gecos(ge), directory(d), shell(s)
    {
        //empty
    }

    friend std::ostream& operator<<(std::ostream&, const passwd_t&);
};

std::ostream& operator<<(std::ostream& out, const passwd_t& p) {
    return out << p.account << ':' << p.password << ':' << p.uid << ':' << p.gid << ':' << p.gecos << ':' << p.directory << ':' << p.shell;
}

std::vector<passwd_t> passwd_list{
    {
        "jsmith", "x", 1001, 1000,
        {"Joe Smith", "Room 1007", "(234)555-8917", "(234)555-0077", "jsmith@rosettacode.org"},
        "/home/jsmith", "/bin/bash"
    },
    {
        "jdoe", "x", 1002, 1000,
        {"Jane Doe", "Room 1004", "(234)555-8914", "(234)555-0044", "jdoe@rosettacode.org"},
        "/home/jdoe", "/bin/bash"
    }
};

int main() {
    // Write the first two records
    std::ofstream out_fd("passwd.txt");
    for (size_t i = 0; i < passwd_list.size(); ++i) {
        out_fd << passwd_list[i] << '\n';
    }
    out_fd.close();

    // Append the third record
    out_fd.open("passwd.txt", std::ios::app);
    out_fd << passwd_t("xyz", "x", 1003, 1000, { "X Yz", "Room 1003", "(234)555-8913", "(234)555-0033", "xyz@rosettacode.org" }, "/home/xyz", "/bin/bash") << '\n';
    out_fd.close();

    // Verify the record was appended
    std::ifstream in_fd("passwd.txt");
    std::string line, temp;
    while (std::getline(in_fd, temp)) {
        // the last line of the file is empty, make sure line contains the last record
        if (!temp.empty()) {
            line = temp;
        }
    }
    if (line.substr(0, 4) == "xyz:") {
        std::cout << "Appended record: " << line << '\n';
    } else {
        std::cout << "Failed to find the expected record appended.\n";
    }

    return 0;
}
