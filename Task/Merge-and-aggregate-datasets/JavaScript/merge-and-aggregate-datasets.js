class Patient {
  constructor(patientID, lastName) {
    this.patientID = patientID;
    this.lastName = lastName;
  }
}

class Visit {
  constructor(visitID, visitDate, score) {
    this.visitID = visitID;
    this.visitDate = visitDate;
    this.score = score;
  }
}

function main() {
  const patients = [
    new Patient("1001", "Hopper"),
    new Patient("4004", "Wirth"),
    new Patient("3003", "Kemeny"),
    new Patient("2002", "Gosling"),
    new Patient("5005", "Kurtz"),
  ];

  const visits = [
    new Visit("2002", "2020-09-10", 6.8),
    new Visit("1001", "2020-09-17", 5.5),
    new Visit("4004", "2020-09-24", 8.4),
    new Visit("2002", "2020-10-08", null),
    new Visit("1001", "", 6.6),
    new Visit("3003", "2020-11-12", null),
    new Visit("4004", "2020-11-05", 7.0),
    new Visit("1001", "2020-11-19", 5.3),
  ];

  // Sort patients by patientID
  patients.sort((a, b) => a.patientID.localeCompare(b.patientID));

  console.log("| PATIENT_ID | LASTNAME | LAST_VISIT | SCORE_SUM | SCORE_AVG |");

  patients.forEach((patient) => {
    const patientVisits = visits.filter((v) => v.visitID === patient.patientID);

    // Find the last visit date
    const validVisitDates = patientVisits
      .map((v) => v.visitDate)
      .filter((date) => date !== "");
    const lastVisit = validVisitDates.length > 0
      ? validVisitDates.reduce((latest, date) => date > latest ? date : latest, "")
      : "   None   ";

    // Calculate score sum and average
    const validScores = patientVisits
      .map((v) => v.score)
      .filter((score) => score !== null);
    const scoreSum = validScores.reduce((sum, score) => sum + score, 0);
    const scoreAverage = validScores.length > 0
      ? scoreSum / validScores.length
      : 0;

    // Format the output
    const patientDetails = [
      patient.patientID.padEnd(12),
      patient.lastName.padEnd(11),
      lastVisit.padEnd(13),
      scoreSum.toFixed(2).padStart(12),
      scoreAverage.toFixed(2).padStart(12),
    ].join("");

    console.log(patientDetails);
  });
}

main();
