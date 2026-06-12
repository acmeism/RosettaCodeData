#include <QApplication>
#include <QFile>
#include <QProgressDialog>

class CpuUsage : public QProgressDialog {
public:
    CpuUsage() : prevIdleTime(0), prevTotalTime(0)
    {
        connect(this, &QProgressDialog::canceled, &QApplication::quit);
        setLabelText(tr("CPU utilization"));
        setCancelButtonText(tr("Quit"));
        startTimer(500);
    }

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
        setValue((1 - (1.0*idleTime-prevIdleTime) / (totalTime-prevTotalTime)) * 100.0);
        prevIdleTime = idleTime;
        prevTotalTime = totalTime;
    }

private:
    int prevIdleTime;
    int prevTotalTime;
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    CpuUsage usage;
    usage.show();
    return app.exec();
}
