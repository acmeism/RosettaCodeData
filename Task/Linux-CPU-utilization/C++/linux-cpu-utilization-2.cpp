#include <QFile>
#include <unistd.h>

int main(int, char *[]) {
    int prevIdleTime = 0, prevTotalTime = 0;
    for (QFile file("/proc/stat"); file.open(QFile::ReadOnly); file.close()) {
        const QList<QByteArray> times = file.readLine().simplified().split(' ').mid(1);
        const int idleTime = times.at(3).toInt();
        int totalTime = 0;
        foreach (const QByteArray &time, times) {
            totalTime += time.toInt();
        }
        qInfo("%5.1f%%", (1 - (1.0*idleTime-prevIdleTime) / (totalTime-prevTotalTime)) * 100.0);
        prevIdleTime = idleTime;
        prevTotalTime = totalTime;
        sleep(1);
    }
}
