#include "commonfun.h"
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QCryptographicHash>
#include <QDateTime>
#include <QDebug>


CommonFun::CommonFun(QObject *parent) : QObject(parent)
{}

bool CommonFun::copyFile(QUrl source, QUrl dest)
{
    QFileInfo sourceFileInfo(source.toLocalFile());
    QFileInfo destFileInfo(dest.toLocalFile());
    QDir destDir(QString("%1/%2/").arg(destFileInfo.absolutePath()).arg(destFileInfo.baseName() + "_image"));
    destDir.mkpath(destDir.absolutePath());

    qDebug()<<QString("%1/%2.%3")
              .arg(destDir.absolutePath())
              .arg(QString(QCryptographicHash::hash(QDateTime::currentDateTime().toString("yyyy MM dd hh:mm:ss:zzz").toUtf8(), QCryptographicHash::Md5).toHex()))
              .arg(sourceFileInfo.completeSuffix());

    return QFile::copy(source.toLocalFile(), QString("%1/%2.%3")
                                     .arg(destDir.absolutePath())
                                     .arg(QString(QCryptographicHash::hash(QDateTime::currentDateTime().toString("yyyy MM dd hh:mm:ss:zzz").toUtf8(), QCryptographicHash::Md5).toHex()))
                                     .arg(sourceFileInfo.completeSuffix()));
}


