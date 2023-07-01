#include <iostream>
#include <optional>
#include <ranges>
#include <string>
#include <vector>

using namespace std;

struct Patient
{
    string ID;
    string LastName;
};

struct Visit
{
    string PatientID;
    string Date;
    optional<float> Score;
};

int main(void)
{
    auto patients = vector<Patient> {
        {"1001", "Hopper"},
        {"4004", "Wirth"},
        {"3003", "Kemeny"},
        {"2002", "Gosling"},
        {"5005", "Kurtz"}};

    auto visits = vector<Visit> {
        {"2002", "2020-09-10", 6.8},
        {"1001", "2020-09-17", 5.5},
        {"4004", "2020-09-24", 8.4},
        {"2002", "2020-10-08", },
        {"1001", ""          , 6.6},
        {"3003", "2020-11-12", },
        {"4004", "2020-11-05", 7.0},
        {"1001", "2020-11-19", 5.3}};

    // sort the patients by ID
    sort(patients.begin(), patients.end(),
         [](const auto& a, const auto&b){ return a.ID < b.ID;});

    cout << "| PATIENT_ID | LASTNAME | LAST_VISIT | SCORE_SUM | SCORE_AVG |\n";
    for(const auto& patient : patients)
    {
        // loop over all of the patients and determine the fields
        string lastVisit;
        float sum = 0;
        int numScores = 0;

        // use C++20 ranges to filter the visits by patients
        auto patientFilter = [&patient](const Visit &v){return v.PatientID == patient.ID;};
        for(const auto& visit : visits | views::filter( patientFilter ))
        {
            if(visit.Score)
            {
                sum += *visit.Score;
                numScores++;
            }
            lastVisit = max(lastVisit, visit.Date);
        }

        // format the output
        cout << "|       " << patient.ID << " | ";
        cout.width(8); cout << patient.LastName << " | ";
        cout.width(10); cout << lastVisit << " | ";
        if(numScores > 0)
        {
            cout.width(9); cout << sum << " | ";
            cout.width(9); cout << (sum / float(numScores));
        }
        else cout << "          |          ";
        cout << " |\n";
    }
}
