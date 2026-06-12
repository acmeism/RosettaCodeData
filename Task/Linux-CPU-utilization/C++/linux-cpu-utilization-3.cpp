#include <QCoreApplication>
#include <QFile>

class CpuUsage : public QObject {
public:
    CpuUsage() : prevIdleTime(0), prevTotalTime(0) { }

protected:
    virtual void timerEvent(QTimerEvent *)
    {
        QFile file("/proc/stat");
        file.open(QFile::ReadOnly);
        const QList<QByteArray> times = file.readLine().simplified().split(' ').mid(1);
        const int idleTime = times.at(3).toInt();
        int totalTime = 0;
        foreach (const QByteArray &time, times) {
            totalTime += time.toInt();
        }
        qInfo("%5.1f%%", (1 - (1.0*idleTime-prevIdleTime) / (totalTime-prevTotalTime)) * 100.0);
        prevIdleTime = idleTime;
        prevTotalTime = totalTime;
    }

private:
    int prevIdleTime;
    int prevTotalTime;
};

int main(int argc, char *argv[]) {
    QCoreApplication app(argc, argv);
    CpuUsage usage;
    usage.startTimer(1000);
    return app.exec();
}
