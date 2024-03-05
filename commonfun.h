#ifndef COMMONFUN_H
#define COMMONFUN_H

#include <QObject>
#include <QUrl>


class CommonFun : public QObject
{
    Q_OBJECT
public:
    explicit CommonFun(QObject *parent = nullptr);
    Q_INVOKABLE bool copyFile(QUrl source, QUrl dest);

signals:

public slots:
};

#endif // COMMONFUN_H
