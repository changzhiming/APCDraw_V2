function dbInit(projectName)
{
    var db = LocalStorage.openDatabaseSync(projectName, "1.0", "工程文件", 1000000);
    db.transaction(function(tx) { tx.executeSql('CREATE TABLE IF NOT EXISTS Page(page_name TEXT, page_info TEXT, childs TEXT)'); } )
}

function dbGetHandle(projectName)
{
    return LocalStorage.openDatabaseSync(projectName, "1.0", "工程文件", 1000000);
}
//cb(page_name)
function dbReadAllPages(cb, projectName)
{
    var db = dbGetHandle(projectName)
    db.transaction(function(tx) {
        var rs = tx.executeSql('select page_name from Page');
        var pageNameList = []
        for(var index = 0; index < rs.rows.length; index++) {
            cb(rs.rows.item(index).page_name)
        }
    })
}
function dbReadOnePage(pageName, fun, projectName) {
    var db = dbGetHandle(projectName)
    db.transaction(function(tx) {
        var rs = tx.executeSql('select * from Page where page_name = ?', pageName);
        if(rs.rows.length > 0) {
            var pageInfo = JSON.parse(rs.rows.item(0).page_info)
            var childs = JSON.parse(rs.rows.item(0).childs)
            fun(pageInfo, childs)
        }
    })
}

function dbNewUpdatePage(pageName, pageInfo, childItems, projectName)
{
    if(pageName === '') {return}
    var db = dbGetHandle(projectName)
    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM Page WHERE page_name=?', [pageName]);
        tx.executeSql('INSERT INTO Page VALUES(?, ?, ?)', [pageName, JSON.stringify(pageInfo), JSON.stringify(childItems)]);
    })
}

function dbCopyPage(pageName, fun, projectName)
{
    var db = dbGetHandle(projectName)
    var pageIndex = 1;
    var newPageName = pageName;
    db.transaction(function(tx) {
        while(true) {
            newPageName = pageName + pageIndex++;
            var rs = tx.executeSql('select * from Page where page_name = ?', newPageName);
            if(rs.rows.length <= 0) {
                break
            }
        }

        db.transaction(function(tx) {
            var rs = tx.executeSql('select * from Page where page_name = ?', pageName);
            if(rs.rows.length > 0) {
                var pageInfo = JSON.parse(rs.rows.item(0).page_info)
                var childs = JSON.parse(rs.rows.item(0).childs)
                pageInfo.pageName = newPageName

                dbNewUpdatePage(newPageName, pageInfo, childs)
                fun(newPageName)
            }
        })
    })
}
function dbDeletePage(pageName, projectName)
{
    var db = dbGetHandle(projectName)
    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM Page WHERE page_name=?', [pageName]);
    })
}
