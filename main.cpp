#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSslSocket>
#include <QFile>
#include <commonfun.h>
#include <QDebug>

int main(int argc, char *argv[])
{
    //qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    //QApplication::setAttribute(Qt::AA_UseOpenGLES);

    QApplication app(argc, argv);
    app.setOrganizationName("汇科智控");
    app.setOrganizationDomain("组态");

    QQmlApplicationEngine engine;

    qmlRegisterSingletonType(QUrl("qrc:/APCCommon/Common.qml"), "Common.API", 1, 0, "JS_DB_API");
    qmlRegisterSingletonType<CommonFun>("Common.API", 1, 0, "C_API", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {  Q_UNUSED(engine)  Q_UNUSED(scriptEngine)  return new CommonFun();});

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    qSetMessagePattern("[%{time h:mm:ss.zzz} %{if-debug}Debug%{endif}%{if-warning}Waring%{endif}%{if-critical}Critical%{endif}%{if-fatal}Fatal%{endif}] %{file}:%{line} : %{message}");

    return app.exec();
}
